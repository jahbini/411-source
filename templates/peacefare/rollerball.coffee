#
# rollerBall -- internally controlled sphere
#

Gravitas = ->
  class RollerBall extends seen.Model
  #
  # tetrasphere -- a spherical hull with tetrahedral attachment points
  #

    TETRAHEDRON_COORDINATE_MAP = [
      [0, 2, 1]
      [0, 1, 3]
      [3, 2, 0]
      [1, 2, 3]
    ]
    tetrahedronPoints = [
      seen.P( 1,  1,  1).normalize()
      seen.P(-1, -1,  1).normalize()
      seen.P(-1,  1, -1).normalize()
      seen.P( 1, -1, -1).normalize()] 
        
    tetrahedralSphere =  (subdivisions = 2) ->
      triangles = TETRAHEDRON_COORDINATE_MAP.map (coords) -> coords.map (c) -> tetrahedronPoints[c]
      for i in [0...subdivisions]
        triangles = seen.Shapes._subdivideTriangles(triangles)
        for triangle in triangles
          for p in triangle
            p.normalize()
            #console.log p, p.
      # return a unit sphereical hull of triangles -- points 0 through 3 are the original
      # attachment points on the unit sphere
      return new seen.Shape('tetrahedralSphere', triangles.map (triangle) -> new seen.Surface(triangle.map (v) -> v.copy()))
     
    # create a seen Model of inner and outer seen sphereish shapes decorated
    # with cannon mass objects connected by tetrahedral force positions
    
    controlPoints: ()->  #return a seen copy of the four normalized tetrahedral points
      p.copy() for p in tetrahedronPoints
    
    # utility to convert points to/from cannon from/to seen
    toVec3 = (p) -> new CANNON.Vec3 p.x, p.y, p.z
    toPoint = (v) -> seen.P v.x,v.y,v.z
    
    constructor: (world, mass=10,radius=100, options={}) ->
      super()
      @world=world
      @mass=mass
      @radius=radius
      
      defaultOptions = 
        massRatio: 0.1
        innerRatio: 0.1
        position: seen.P() 
        
      @config = Object.assign {},defaultOptions ,options
      @innerSphere = new (CANNON.Body)(
        mass: @mass * (1-@config.massRatio)
        position: toVec3 @config.position
        shape: new (CANNON.Sphere)(1))
      @outerSphere = new (CANNON.Body)(
        mass: @mass * @config.massRatio
        position: toVec3 @config.position
        shape: new (CANNON.Sphere)(@radius))
      #debugger
      @innerSphere.aName = "Innie"
      @innerSphere.collisionResponse=false
      @outerSphere.aName = "Outie"
      @world.addBody @innerSphere
      @world.addBody @outerSphere
      
      @.add @.outerHull=tetrahedralSphere(4).scale(@radius).fill new seen.Material seen.C 200,200,20,200
      @.add @.innerHull = tetrahedralSphere(2).scale(@radius * @config.innerRatio).fill new seen.Material seen.C 20,200,200,200
      for i in [0..3]
        pInner = tetrahedronPoints[i].copy().multiply @radius * @config.innerRatio
        pOuter = tetrahedronPoints[i].copy().multiply @radius
        pipe = seen.Shapes.pipe pInner,pOuter
        @.add pipe.fill new seen.Material seen.C 20,20,20,100
      @.bake()
      return @
    
    update: ()->
      # map the physics simulation objects to seen's visual toolkit
      console.log "outie",po=@.outerSphere.position
      console.log "innie",pi=@.innerSphere.position
      @.reset().translate po.x,po.y,po.z
      @.innerHull.reset().translate pi.x-po.x,pi.y-po.y,pi.z-po.z
      return
      
  # Setup our world
  world = new (CANNON.World)
  world.gravity.set 0, 0, -9.82
  # m/s²

  # Create a plane
  groundBody = new (CANNON.Body)(mass: 0)
  groundShape = new (CANNON.Plane)
  groundBody.addShape groundShape
  groundBody.aName = "floorie"
  world.addBody groundBody

  width = 400
  height = 400
 
  rBall = new RollerBall world,100,30, position:seen.P 5,0,100
  rBall2 = new RollerBall world,10,20, position:seen.P 5,5,50
  # Create scene and add shape to model
  scene = new seen.Scene
    model    : seen.Models.default().add(rBall).add rBall2
    viewport : seen.Viewports.center(width, height)
  
  floor = seen.Shapes.patch 50,50
  floor.translate -25,-25,0
  floor.roty Math.PI
  floor.fill new seen.Material seen.C 100,100,100,100
  floor.eachSurface (s)-> s.cullBackfaces = false
  scene.model.add floor.scale -50
  #put some easily recognizable grid elements
  for x in [-5..5]
    for y in [-5..5]
      scene.model.add seen.Shapes.pipe seen.P(10*x,10*y,x*y),seen.P(10*x,10*y,0)
  
  # Create render context from canvas
  context = seen.Context('seen-canvas', scene).render()
  #context.layer(new seen.FillLayer(width, height, '#0005'))
  #debugger
  FLIPXZ = new seen.Matrix [0, 0, 1, 0,
            0, 1, 0, 0,
            1, 0, 0, 0,
            0, 0, 0, 1]
  FLIPYZ = new seen.Matrix [1, 0, 0, 0,
            0, 0, 1, 0,
            0, 1, 0, 0,
            0, 0, 0, 1]
  scene.model.transform FLIPYZ
  scene.model.rotx Math.PI*20/360
  scene.model.bake()

  timeStamp = 0
  
  rotateThem=(t, dt) ->
    fixedTimeStep = 1.0 / 60.0
    # seconds
    maxSubSteps = 3
    lastTime = undefined
    debugger
    world.step fixedTimeStep, dt, maxSubSteps
    #console.log 'Sphere z position: ' + bouncingSphere.position.z, 'max',maxVelocity
    timeStamp += dt*1e-2
    
    rBall.update()
    rBall2.update()
  
    return


  seenModel = scene.model.append()
  # Add mouse-rotate
  dragger = new seen.Drag('seen-canvas', {inertia : true})
  dragger.on('drag.rotate', (e) ->
    xform = seen.Quaternion.xyToTransform(e.offsetRelative...)
    scene.camera.transform(xform)
  )

  # Add mousewheel-zoom
  zoomer = new seen.Zoom('seen-canvas', {smooth : false})
  zoomer.on('zoom.scale', (e) ->
    xform = seen.M().scale(e.zoom)
    scene.camera.transform(xform)
  )
  context.animate()
    .onBefore rotateThem
    .start()
  
  #
  # ## Apache 2.0 License
  
  #     Copyright 2013, 2014 github/themadcreator
  
  #   Licensed under the Apache License, Version 2.0 (the "License");
  #   you may not use this file except in compliance with the License.
  #   You may obtain a copy of the License at
  
  #     http://www.apache.org/licenses/LICENSE-2.0
  
  #   Unless required by applicable law or agreed to in writing, software
  #   distributed under the License is distributed on an "AS IS" BASIS,
  #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  #   See the License for the specific language governing permissions and
  #   limitations under the License.
  # 
#-------- class start
class  index extends celarientemplate
  #
  # section storyHeadMatter
  #
  storyHeadMatter: ->
    T.script src:"http://seenjs.io/dist/latest/seen.min.js"
    T.script src:"draft/peacefare/rollerball/cannon.js"
    T.script src:src="//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.7.1/coffee-script.min.js"
    T.script type:"text/coffeescript", """

  """
  # 
  # section html
  # 
  # 
  # section celarien_body
  # 
  # 
  # section cover
  # 
  cover: =>
    T.div "#cover", style: "background-image:url(/assets/images/hooray-fade2.jpg);-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH"
  # 
  # section footer
  # 
  # 
  # section sidecar
  # 
  # 
  # section fb_status
  # 
  # 
  # section sidebar
  # 
  # 
  # section storybar
  # 
  storybar: =>
    T.div "#storybar.o-grid__cell.order-2.bg-lighten-2", =>
      T.h1 => T.raw "Celarien -- The tools of the spiritual bodyguard"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", =>
      T.p => T.raw "How’s life working out for you?  What is your coping style?"
      T.canvas "#seen-canvas",width:400, height:400 
      T.coffeescript Gravitas 

      T.p => T.raw "If you want the spiritual tools to guard yourself against the lies that are keeping you stressed out, afraid, demoralized or angry, keep reading."
  # 
  # section header
  # 
  header: ->
    
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end
page = new index
rendered =  T.render page.html
# ------- db start
db = {} unless db

#
db[id="celarienpeacefarerollerball"] =
  title: "rollerball"
  slug: "rollerball"
  category: "peacefare"
  site: "597aea40d3cfff7cc5f926f0"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-04-04T21:10:55.084Z"
  lastEdited: "2018-04-04T21:10:55.085Z"
  published: "2018-04-04T21:10:55.085Z"
  embargo: "2018-04-04T21:10:55.085Z"
  captureDate: "2018-04-04T21:10:55.085Z"
  TimeStamp: 1522876255085
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarienpeacefarerollerball"
  name: "rollerball"
#
#end of story