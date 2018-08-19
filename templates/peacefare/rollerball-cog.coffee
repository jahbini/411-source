#
# rollerBall -- internally controlled sphere
#

###! for Console redirection
Copyright (C) 2011 by Marty Zalega

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

Gravitas = ->
  #include console.coffee
  class TetraForcer
    MINFORCE = 25
    constructor: (body,@e)->
      @tetraPoint = @e.cannonLocal
      @outerSphere = body.outerSphere
      @innerSphere = body.innerSphere
      @body = body
      @seekerPID = new PID -100,1,-0.1, 1/60.0
      @seekerPID.setTarget = 0
      @.seek = bind @.seek, @
    ###
     pursuit.z = @body.radius * 2  
      seekVector = pursuit.vsub @outerSphere.position
      seekPosition = @outerSphere.position.vadd seekVector.unit().scale @body.radius *.8
      tetraPosition = @outerSphere.pointToWorldFrame @tetraPoint
      force = MINFORCE
      if seekPosition.distanceTo(tetraPosition) > @innerSphere.position.distanceTo(tetraPosition)
        force += @seekerPID.update @innerSphere.position.distanceTo seekPosition
      else
        force += @seekerPID.update 0
      tetraVector = (tetraPosition.vsub @innerSphere.position).unit().scale @body.mass
      @innerSphere.applyForce (tetraVector.scale force),@innerSphere.position
      @outerSphere.applyForce (tetraVector.scale -force),tetraPosition
      return
    ###
    seek: (pursuit) -> # the real world position
      pursuit.z = @body.radius * 2  
      seekVector = pursuit.vsub @outerSphere.position
      seekPosition = @outerSphere.position.vadd seekVector.unit().scale @body.radius *.8
      tetraPosition = @outerSphere.pointToWorldFrame @tetraPoint
      force = MINFORCE
      @tetraToPursuit = pursuit.distanceTo(tetraPosition)
      @tetraToPursuit = seekPosition.distanceTo(tetraPosition)
      @toInnie =@innerSphere.position.distanceTo(seekPosition)
      @innieToPursuit = pursuit.distanceTo @innerSphere.position
      @tetraToInnie = tetraPosition.distanceTo @innerSphere.position
      if @tetraToPursuit < @tetraToInnie
        adjust = @toInnie
        debugger
        if @body.A == "Biggie"
          console.log @e.viewAttributes.name,adjust
      else
        adjust = 0
      adjust = @seekerPID.update adjust
      @force = force + adjust
      tetraVector = (tetraPosition.vsub @innerSphere.position).unit().scale @body.mass
      @innerSphere.applyForce (tetraVector.scale @force),@innerSphere.position
      @outerSphere.applyForce (tetraVector.scale @force*-1),tetraPosition
      return

  class RollerBall
    
    # utility to convert points to/from cannon from/to seen
    toVec3 = (p) -> new CANNON.Vec3 p.x/10, p.y/10, p.z/10
    toPoint = (v) -> seen.P v.x*10,v.y*10,v.z*10
    C = (x=0,y=0,z=0)-> new CANNON.Vec3 x,y,z
    
    TETRAHEDRON_COORDINATE_MAP = [
      [0, 2, 1]
      [0, 1, 3]
      [3, 2, 0]
      [1, 2, 3]
    ]
    # the raw values of the tetrahedron points -- useful in several places
    tetrahedronPoints = [
      seen.P( 1,  1,  1)
      seen.P(-1, -1,  1)
      seen.P(-1,  1, -1)
      seen.P( 1, -1, -1)] 
    # algorithmic generation
    tetrahedralDescription=[]
    do -> 
      r=[ 1,-1]
      for z in r
        for y in r
          tetrahedralDescription.push
            p: seen.P z*y,y,z
            raw: [ z*y,y,z]
            cannonLocal: C z*y,y,z
            index: tetrahedralDescription.length
      return

    #
    # tetrasphere -- a spherical hull with tetrahedral attachment points
    #
    tetrahedralSphere =  (subdivisions = 2) ->
      triangles = TETRAHEDRON_COORDINATE_MAP.map (coords) -> coords.map (c) -> tetrahedronPoints[c]
      for i in [0...subdivisions]
        triangles = seen.Shapes._subdivideTriangles(triangles)
        for triangle in triangles
          for p in triangle
            p.normalize()
      # return a unit sphereical hull of triangles -- points 0 through 3 are the original
      # attachment points on the unit sphere
      return new seen.Shape('tetrahedralSphere', triangles.map (triangle) -> new seen.Surface(triangle.map (v) -> v.copy()))
     
    # create a seen Model of inner and outer seen sphereish shapes decorated
    # with cannon mass objects connected by tetrahedral force positions
    accessControlPoints: (f) =>
      for element in @controlPoints
        f element
    window.bind1=bind #hack
    setPursuit: (x,y)->
      @pursuit = new CANNON.Vec3 x, y,-10
      p1 = toPoint @pursuit
      p1.z=0
      p2 = p1.copy().add seen.P 0,0,20
      pipe=seen.Shapes.pipe p1,p2,0.3,6
      @avatar.add pipe.fill new seen.Material seen.C 20,20,20
      return

    # mass in kg, distance in meters
    constructor: (name,world, mass=1,radius=0.2, options={}) ->
      @A = name
      @world=world
      @scene = world.scene
      @avatar = world.scene.model
      @mass=mass
      @radius=radius
      @setPursuit 0,0
      @controlPoints = for v in tetrahedralDescription
        Object.assign {}, v
      
      
      defaultOptions = 
        massRatio: 0.1
        innerRatio: 0.1
        position: seen.P() 
        
      @config = Object.assign {},defaultOptions ,options
      @innerSphere = new (CANNON.Body)(
        mass: @mass * (1-@config.massRatio)
        position: @config.position
        shape: new (CANNON.Sphere)(@radius * @config.innerRatio))
      @outerSphere = new (CANNON.Body)(
        mass: @mass * @config.massRatio
        angularDamping: 0
        position: @config.position
        shape: new (CANNON.Sphere)(@radius))
      #debugger
      @innerSphere.aName = "#{@A}.Innie"
      #@innerSphere.collisionResponse=false
      @innerSphere.collisionFilterGroup = 1
      @innerSphere.collisionFilterMask = 1
      @outerSphere.aName = "#{@A}.Outie"
      @outerSphere.collisionFilterGroup = 2
      @outerSphere.collisionFilterMask = 2
      @world.addBody @innerSphere
      @world.addBody @outerSphere
      
      # build up an array of structures for the anchor points
      @accessControlPoints (e)=>
        e.tetraForcer = new TetraForcer @, e
        
      # set up simulation-step update routine for feint and final position force
      world.addEventListener "preStep",(event)=>
        who=@A
        @accessControlPoints (e)=>
          e.tetraForcer.seek @pursuit
        return
        
      world.addEventListener "postStep",(event)=>
        @.innerSphere.velocity.scale .97,@.innerSphere.velocity
        @.outerSphere.velocity.scale .98,@.outerSphere.velocity
        return
      # end of physical simulation stuf
      #
      #visual (avatar) stuff
      # scene model for the control force tetrahedron 
      @.avatar.add @.innerHull = seen.Shapes.tetrahedron().scale(10*@radius * @config.innerRatio).fill new seen.Material seen.C 20,200,200,200
      @.innerHull.bake()
      # create seen model for outerHull & it's decorations
      @.outerHull = new seen.Model()
      @.outerHull.add seen.Shapes.sphere().scale(@radius*10).fill new seen.Material seen.C 200,200,20,200
      @.outerHull.bake()
      @.contolPairs=[]
      tetraNames = ["orange","blue","green","violet"]
      colorHex = ["#FDD459", "#46e1d4","#24C52B","#C31A96"]
      @accessControlPoints (e)->
        e.viewAttributes =
          name: tetraNames[e.index]
          color: colorHex[e.index] 
      @accessControlPoints (e)=>
        pInner = e.p.copy().multiply 5*@radius * @config.innerRatio
        pOuter = e.p.copy().multiply 5*@radius
        pipe = seen.Shapes.pipe pInner,pOuter,0.1,3
        pipe.name = e.viewAttributes.name
        pipe.anchor = pOuter
        e.pipe = pipe
        @outerHull.add pipe.fill new seen.Material seen.Colors.parse e.viewAttributes.color
        @.contolPairs.push [pInner,pOuter]
      @avatar.add @outerHull
      return
    # end setup
    # visual updates for innie and outie
    update: ()->
      who=@A
      # map the physics simulation objects to seen's visual toolkit
      po=toPoint @.outerSphere.position
      pr=@outerSphere.quaternion
      rotation = new seen.Quaternion pr.x,pr.y,pr.z,pr.w
      #console.log "outie",po
      
      pi=toPoint @.innerSphere.position
      #console.log "innie",pi
      @.innerHull.reset().transform rotation.toMatrix()
      @.innerHull.translate pi.x,pi.y,pi.z
      @.outerHull.reset().transform rotation.toMatrix()
      @.outerHull.translate po.x,po.y,po.z
      
      return
  
  console=Console "console0",window
  # Setup our world
  world = new (CANNON.World)
  # m/s²
  world.gravity.set 0, 0, -9.82
  leather = new CANNON.Material friction: .3, restitution: 0.3
  world.defaultMaterial.friction = 0.3
  world.defaultMaterial.restitution = 0.3

  # Create a plane
  groundBody = new (CANNON.Body)(mass: 0)
  groundShape = new (CANNON.Plane)
  groundBody.addShape groundShape
  groundBody.aName = "floorie"
  groundBody.collisionFilterGroup = -1
  groundBody.collisionFilterMask = -1
  world.addBody groundBody
  
  width = 400
  height = 400
  console.log "Width #{width}. Height #{height}"
  # Create scene and add shape to model
  world.scene = scene = new seen.Scene
    model    : seen.Models.default()
    viewport : seen.Viewports.center(width, height)
  avatar = world.scene.model 
  balls = []
  allBall = (r)->
    r b for b in balls
  
  balls.push new RollerBall "Biggie",world,100,0.50, position:new CANNON.Vec3 1,1,0.75
  #balls.push new RollerBall "mannie",world,10,0.30, position:new CANNON.Vec3 1,1.3,5
  #balls.push new RollerBall "moe",world,10,0.30, position:new CANNON.Vec3 0,1.3,4
  #balls.push new RollerBall "jack",world,10,0.30, position:new CANNON.Vec3 1.2,1.3,6
  
  xform = seen.M().rotx(.3).scale(3)
  scene.camera.transform(xform).bake()
  
  floor = seen.Shapes.patch 50,50
  floor.translate -25,-25,0
  floor.roty Math.PI
  floor.fill new seen.Material seen.C 100,100,100,100
  floor.eachSurface (s)-> s.cullBackfaces = false
  avatar.add floor.scale -50
  #put some easily recognizable grid elements
  for x in [-5..5]
    for y in [-5..5]
      avatar.add seen.Shapes.pipe seen.P(x*10,y*10,1),seen.P(x*10,y*10,0),0.5
  
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
  startStop = false
  onceStop = false
  dropTime = 10000
  simulateThem=(t, dt) ->
    fixedTimeStep = 1.0 / 60.0
    # seconds
    maxSubSteps = 3
    lastTime = undefined
    if t>dropTime & balls.length <10
      dropTime = t+fixedTimeStep*100000
      #console.log "pushing new ball",t
      balls.push new RollerBall "jack_#{dropTime}",world,10,0.30, position:new CANNON.Vec3 4,4,6
    if startStop
      if onceStop
        startStop = false
        onceStop = false
        allBall (b)->console.log b.A,b.outerSphere.position,b.innerSphere.position
        #debugger
      world.step fixedTimeStep, dt, maxSubSteps
    #
    timeStamp += dt*1e-2
    allBall (b)-> b.update()
  
    return

  m=Pylon.Mithril

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
    .onBefore simulateThem
    .start()
  
  window.onkeypress= (event)->
    switch event.key
      when "."
        onceStop = true 
        startStop = true 
      when ' '
        startStop = !startStop
      when 'h'
        allBall (b)->
          b.setPursuit -5,0
      when 'j'
        allBall (b)->
          b.setPursuit 4,4   
      when 'k'
        allBall (b)->
          b.setPursuit -3,-3
      when 'l'
        allBall (b)->
          b.setPursuit 0,0
    return
  
  #
  # ## Apache 2.0 License
  
  #     Copyright 2017, 2018 github/jahbini
  
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
renderer = class  index extends _411SourceTemplate
  #
  # section storyHeadMatter
  #
  storyHeadMatter: ->
    T.script src:"https://aframe.io/releases/0.5.0/aframe.min.js"
    T.script src:"draft/peacefare/rollerball-cog/aframe-physics-system.js"
    T.script src:"assets/seen.min.js"
    T.script src:"draft/peacefare/rollerball/cannon.js"
    T.script src:"draft/peacefare/rollerball/pid.js"
    T.script src:src="//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.7.1/coffee-script.min.js"
    T.script type:"text/coffeescript", """

  """
    T.style type:"text/css","""
#include console.css
"""
  # 
  # section html
  # 
  # 
  # section site_body
  # 
  # 
  # section cover
  # 
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
  sidebar: =>
    T.aside "#sidebarx.o-grid__cell.o-grid__cell--width-20.p2.bg-darken-2", style: "min-width:240"
  # 
  # section storybar
  # 
  storybar: =>
    T.div "#storybar.o-grid__cell.order-2.bg-lighten-2", =>
      T.h1 => T.raw "How to wage peace in a terrorized society."
      T.h3 => "The 411-source's tools of the spiritual bodyguard"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div ".container",->
    T.h3 "The LowRoller version of the RollerBall"
    T.div "#bloviation.contents", =>
      T.p """Did you ever see a Samurai movie where the police take down a rampaging samuri?"""
      T.p """They simply surrounded the samuri with wooden staffs to keep him farther than swords length, and poked him until he gave up.  we have nothing like that for a man with a gun.  Enter the LowRoller"""
      T.p """The LowRoller rollerBall is about the size of a basketball or soccerball.  It is
covered with a hard shell with a surface like leather.  It's mass is a few kilograms.
It can alter it's center of gravity to roll around.  that's it.
"""
      T.p  """Even with that limitation, it can gang up at the feet of a person causing a threat.
The random motions of the balls will make the attacker lose balance and be unable to continue.
"""
      T.p  """Press the spacebar to start and stop the simulation.  The large ball is a meter in diameter.
press '.' to single step the simulation.
"""
      T.canvas "#seen-canvas",width:400, height:400 
      #T.input "#red-slider",type:"range", min:0,max:255,onchange: "alert('wow')"
      T.p => T.raw "Press hjkl to change where these rollerballs take down an attacker."
      T.p => "Rotate the view with click and drag.  Zoom with fingers or mouse wheel."
  # 
  # section header
  # 
  header: ->
    
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end


# ------- db start
db = {} unless db

#
db[id="411-source/peacefare/rollerball-cog"] =
  title: "rollerball"
  slug: "rollerball-cog"
  category: "peacefare"
  site: "411-source"
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
  id: "411-source/peacefare/rollerball-cog"
  name: "Low Roller"
#