
height=800
T=require "halvalla"
B=require "backbone"
_= require "underscore"

rho = 15/1.618033  #set powers[0] to 15
powers = for i in [0..10]
  rho = rho * 1.61803398
dumpText= (text...)->
  r="--"
  for t in text
    if _.isString t
      r += t
    else
      r += JSON.stringify t
    r+=" --"

  $("#reference").append T.render T.p r
rhoShow = T.render T.div =>
  for i in [0..10]
    T.p "rho^#{i}=#{powers[i]}. "
  return null
#$("#reference").append rhoShow

Ratios = [2,1,0,-1]
colorScheme = [
  '#e6194B', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#42d4f4', '#f032e6', '#bfef45', '#fabed4', '#469990', '#dcbeff', '#9A6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#a9a9a9', '#ffffff', '#000000' ]


blades={}
for basis,i in [ "groucho","harpo","chico","stan","babe"]
   color =  seen.Colors.hex colorScheme[i]
   color.a = 140
   slope = i * 2 * Math.PI/5
   blades[basis] =
     angle: i*72
     slope: slope
     points: for v,k in powers
       new seen.P().transform( new seen.Matrix().translate(v).rotz slope)
     color: color

fillColor = seen.Colors.rgb 255,5,5
newDot =(theColor = fillColor, text="origin")->
  #shape = seen.Shapes.text(text, {font: '10px Roboto', cullBackfaces: false, anchor: 'left'}).fill('#000000')
  shape = new seen.Shape('tri', [new seen.Surface([seen.P(4, 0, 0), seen.P(0, -1, 0), seen.P(0, 1, 0)])])
  shape.fill(new seen.Material(theColor)).scale 5

latticePoint = B.Model.extend()
latticePointCollection =B.Collection.extend
  model:latticePoint
latticePoints = new latticePointCollection()
addToLattice = (who,where,what,parent)->
  try
    pointFinal = seen.P(0,0,0).transform(what.m).round()
    return null unless 1000 > pointFinal.magnitude()
    sig= siggy parent, who, where
    #dumpText "lattice sig", sig, who,parent
    latticePoints.add
      id:what.surfaces[0].id
      blade: who
      offset: where
      pointFinal: pointFinal
      signature: sig
  catch badboy
    alert "233 "+badboy

latticeOrigin =new latticePoint
  id:"o0"
  blade:"origin"
  offset: 0
  pointFinal: seen.P 0,0,0
  signature: "_"
#latticePoints.add latticeOrigin
dot=null

seenModels = new seen.Models.default()
bladeScheme=  [ "groucho","harpo","chico","stan","babe","groucho","chico","babe","harpo","stan","groucho"]

class Paths
  # local p accumulates all Paths to a specific vertex from the origin
  constructor: ->
    @p = {}

  addPath: (v, data) ->
    bladesInPath =t = data.split '/'
    path= _.sortBy(t,(d)-> d)
    data= path.join '/'
    @p[v.x] ={} unless @p[v.x]
    #dumpText JSON.stringify v
    #dumpText data
    unless t= @p[v.x][v.y]
      @p[v.x][v.y] = [data]
      return true
    #return false unless -1 == _.indexOf t, data
    ## this adds more links to vertex lets just try the first in the class
    #t.unshift data
    return true
    
  mostPaths: ()->
    max = []
    for x,byY of @p
      for y,byXY of byY
        max.push byXY if byXY.length >max.length
    return {x:x, y:y, max: max}
allPaths = new Paths()

siggy = (p,blade,wp)->
  "#{p.get "signature"}/#{blade}-#{blades[blade].angle}.#{wp}"

Origin = new seen.Shape('tri', [new seen.Surface([seen.P(0, 4, 0), seen.P(1, 0, 0), seen.P(-1,0, 0)])])
Origin.fill(new seen.Material('#880000')).scale 5
seenModels.add Origin

createEmplace = (parent = latticeOrigin,blade,inputPower=0)->
  direction=1
  if inputPower<0
    direction=-1
    inputPower=-inputPower
  bladeModel = seenModels.append()
  buildPoint = (blade,thePower,theParent)->
    return unless theParent
    try
      {x,y,z} = theParent.get "pointFinal"
      signature= siggy theParent, blade, thePower
      #dumpText "build",signature
      b = blades[blade]
      bb = b.points[thePower]
      dot = newDot(blades[blade].color,signature).rotz(b.slope).translate(bb.x*direction,bb.y*direction,0).translate x, y, z
      dot.bake().reset()
      #dumpText "dot", signature, dot
      bladeModel.add dot
      return null unless allPaths.addPath seen.P(0,0,0).transform(dot.m).round(),signature
    catch badboy
      alert badboy
    return addToLattice blade,thePower,dot,theParent

  pipeIt = ( s,d,color) ->
    interpolatePoints = (a, b, t) ->
      return seen.P(
        a.x*(1.0 - t) + b.x*t
        a.y*(1.0 - t) + b.y*t
        a.z*(1.0 - t) + b.z*t
      )
    sp= s.get "pointFinal"
    dp= d.get "pointFinal"
    ln1 = seen.Shapes.pipe  (interpolatePoints sp, dp, .9),(interpolatePoints sp, dp, .2)
    ln1.fill color
    bladeModel.add ln1
  
  #alert "in create #{blade} #{inputPower}"
  newPoint = buildPoint blade,inputPower,parent
  pipeIt parent,newPoint,colorScheme[inputPower+5]
  newPoint

start= latticeOrigin

while inputPath
  result = inputPath.match /(harpo|groucho|chico|stan|babe)(-?[0-9]*)(.*)$/
  inputPath= result[3]
  #dumpText result
  start = createEmplace start,result[1],result[2]


dumpText "JAH here"
dumpText latticePoints.length
g= allPaths.mostPaths()
dumpText "popular destination", g

#latticePoints.forEach (l)->dumpText l.toJSON()
#fillColor = seen.Colors.rgb 25,99,188,40
dumpText "JAH where"

dumpText "JAH nowhere"

#
# Create scene and add shape to model
scene = new seen.Scene
  model    : bigM = seenModels
  viewport : seen.Viewports.center(height, height)
  camera   : new seen.Camera
          projection : seen.Projections.perspective()

# Create render context from canvas
context = seen.Context 'seen-canvas', scene
context.render()

#dragger = new seen.Drag('seen-canvas', {inertia : true})
#dragger.on 'drag.rotate', (e) ->
#  bigM.transform seen.Quaternion.xyToTransform(e.offsetRelative...)
#  context.render()

