
height=800
T=require "halvalla"
B=require "backbone"
_= require "underscore"

rho = 50/1.618033  #set powers[0] to 50
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

class Triangle extends Backbone.Model
  constructor:()->
class Triangles extends Backbone.Collection
  model: Triangle
  constructor: ()->
    

allTriangles = new Triangles()

#prototype for new edge
#allEdges.pipeIt parent,destination,colorScheme[inputPower+5]
class Edge extends Backbone.Model
  constructor: ()->
class Edges extends Backbone.Collection
  model: Edge
  pipeIt: ( s,d,color) ->
    interpolatePoints = (a, b, t) ->
      return seen.P(
        a.x*(1.0 - t) + b.x*t
        a.y*(1.0 - t) + b.y*t
        a.z*(1.0 - t) + b.z*t
      )
    sp= s.get "pointFinal"
    dp= d.get "pointFinal"
    @add sp,dp
    ln1 = seen.Shapes.pipe  (interpolatePoints sp, dp, .9),(interpolatePoints sp, dp, .2)
    ln1.fill color
    bladeModel.add ln1

allEdges = new Edges()
  
class Point
  constructor: ()->
class Points extends Backbone.collection
  model: Point
  addToLattice: (who,where,what,parent)->
    try
      pointFinal = seen.P(0,0,0).transform(what.m).round()
      return null unless 1000 >= pointFinal.magnitude()
      sig= siggy parent, who, where
      dumpText "New Point", sig, who,parent
      @add
        id:what.surfaces[0].id
        blade: who
        offset: where
        pointFinal: pointFinal
        signature: sig
    catch badboy
      alert "233 "+badboy

allPoints = new Points()

fillColor = seen.Colors.rgb 255,5,5
newDot =(theColor = fillColor, text="origin")->
  #shape = seen.Shapes.text(text, {font: '10px Roboto', cullBackfaces: false, anchor: 'left'}).fill('#000000')
  shape = new seen.Shape('tri', [new seen.Surface([seen.P(-1, -1, 0), seen.P(1, -1, 0), seen.P(0, 4, 0)])])
  shape.fill(new seen.Material(theColor)).scale 5

latticeOrigin =new latticePoint
  id:"o0"
  blade:"origin"
  offset: 0
  pointFinal: seen.P 0,0,0
  signature: "_"
allPoints.add latticeOrigin
dot=null

seenModels = new seen.Models.default()
bladeScheme=  [ "groucho","harpo","chico","stan","babe","groucho","chico","babe","harpo","stan","groucho"]

siggy = (p,blade,wp)->
  "#{p.get "signature"}/#{blade}-#{blades[blade].angle}.#{wp}"

Origin = new seen.Shape('tri', [new seen.Surface([seen.P(-1, -1, 0), seen.P(1, -1, 0), seen.P(0, 4, 0)])])
Origin.fill(new seen.Material('#880000')).scale 5
seenModels.add Origin
#
#createEmplace2 lx[0],4
createEmplace=(parent,inputPower)->
  if inputPower >= 0
    for i in [0..4]
      blade = bladeScheme[i]
      #dumpText "spoke",blade,inputPower
      destination=buildPoint blade,inputPower,parent
      continue unless destination
      #dumpText "destination",destination
      allEdges.pipeIt parent,destination,colorScheme[inputPower+5]
  else  # old tiling method generated multiple names
    for i in [0..4]
      [blade2,blade1] = bladeScheme[i..i+1]
      #dumpText "first leg",blade1,blade2
      parent2=buildPoint blade1,0,parent
      continue unless parent2
      #dumpText "parent2", parent2
      pipeIt parent,parent2,'#123456'
      destination = buildPoint blade2, 0, parent2
      continue unless destination
      #dumpText "destination",blade2,destination
      pipeIt parent2,destination,'#345612'

    for i in [5..9]
      [blade1,blade2] = bladeScheme[i..i+1]
      #dumpText blade1+","+blade2
      parent2=buildPoint blade1,2,parent
      #dumpText JSON.stringify parent2
      pipeIt parent,parent2,'#456123'
      continue unless parent2
      destination=buildPoint blade2,1,parent2
      #dumpText JSON.stringify destination
      pipeIt parent2,destination,'#5eee23'

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

