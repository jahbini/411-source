
height=400
T=require "halvalla"
$("reference").innerHtml = T.div =>
  rho = 1
  powers = for i in [0..100]
    rho = rho * 1.61803398
    T.text "rho^#{i}=#{rho}. "
pp={}
###
i=0
for slope in [ "groucho","chico","harpo","stan","babe"]
   pp.slope = i * Math.PI*2/5
###
shape = seen.Shapes.tetrahedron
shape = new seen.Shape('tri', [new seen.Surface([
    seen.P(-1, -1, 0)
    seen.P( 3, -1, 0)
    seen.P( 0,  1, 0)
])]).scale(height * 0.2)
shape.fill(new seen.Material(seen.Colors.gray()))
# Create scene and add shape to model
scene = new seen.Scene
  model    : seen.Models.default().add(shape)
  viewport : seen.Viewports.center(400, 400)
  camera   : new seen.Camera
          projection : seen.Projections.perspective()
#
# Create render context from canvas
context = seen.Context 'seen-canvas', scene
context.render()

dragger = new seen.Drag('seen-canvas', {inertia : true})
dragger.on 'drag.rotate', (e) ->
  shape.transform seen.Quaternion.xyToTransform(e.offsetRelative...)
  context.render()

