
height=800
T=require "halvalla"
rho = 10
powers = for i in [0..100]
  rho = rho * 1.61803398
dumpText= (text)->
  $("#reference").append T.render T.p text
rhoShow = T.render T.div =>
  for i in [0..10]
    T.p "rho^#{i}=#{powers[i]}. "
  return null
#$("#reference").append rhoShow

blades={}
for slope,i in [ "groucho","chico","harpo","stan","babe"]
   blades[slope] = i * Math.PI*2/5
   blades[slope].points= []

newDot =()->
  shape = new seen.Shape('tri', [new seen.Surface([seen.P(-1, -1, 0), seen.P(1, -1, 0), seen.P(0, 1, 0)])])
  #seen.Lights.point(intensity: 0.1, color: seen.Colors.rgb 240,0,0)
  shape.fill(new seen.Material(seen.Colors.rgb(255,255,255)))

latticePoints ={}

addToLattice = (who,where,what)->
  latticePoints[who] = {} unless latticePoints[who]
  latticePoints[who][where] = {
    pointFinal: seen.P(0,0,0).transform(what.m).round()
    seenSurface: what
  }

dot=null
notdot = null
seenModels = new seen.Model()  # was  s.default()
createEmplace = (x=0,y=0)->
  for blade of blades
    bladeModel = seenModels.append()
    for i in [0..10]
      dot = newDot().translate(powers[i],0,0).bake()
      notdot = dot.rotz blades[blade]
      bladeModel.add dot
      addToLattice blade,i,dot
      #dot = newDot().translate(-powers[i],0,0)
      #bladeModel.add dot
      #addToLattice blade,i,dot
    bladeModel.rotz blades[blade]
createEmplace()
###
for comic of latticePoints
  for i in [4..6]
    p=latticePoints[comic][i].pointFinal
    dumpText "#{comic} - #{i} [#{p.x},#{p.y}]"
#
#
bladeNames = for comic of latticePoints
  comic
dumpText bladeNames.join ', '
dumpText JSON.stringify latticePoints.stan[4]
#what.sceneSurface.surfaces[0].m.baked).rotz blades[who].slope
###
# Create scene and add shape to model
scene = new seen.Scene
  model    : bigM = seenModels
  viewport : seen.Viewports.center(height, height)
  camera   : new seen.Camera
          projection : seen.Projections.perspective()
#
# Create render context from canvas
context = seen.Context 'seen-canvas', scene
context.render()

dragger = new seen.Drag('seen-canvas', {inertia : true})
dragger.on 'drag.rotate', (e) ->
  bigM.transform seen.Quaternion.xyToTransform(e.offsetRelative...)
  context.render()

