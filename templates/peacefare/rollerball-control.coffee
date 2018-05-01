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
  T=Pylon.Halvalla
  bind = (func, inst) ->
    args = toArray(arguments).slice(2)
    ->
      func.apply inst or this, args.concat(toArray(arguments))
      return
  do ->
    consoles = {}
  
    History = ->
      index = -1
      history = []
      extend this,
        clear: ->
          history = []
          return
        reset: ->
          index = history.length
          return
        previous: ->
          history[index = Math.max(--index, 0)]
        next: ->
          history[index = Math.min(++index, history.length)]
        push: (data) ->
          if history[history.length - 1] != data
            history.push data
            @reset()
          return
  
    Console = (el, scope) ->
      jsonize = (msg) ->
        stringify = (obj, replacer, spaces, cycleReplacer) ->
          JSON.stringify obj, serializer(replacer, cycleReplacer), spaces
        serializer = (replacer, cycleReplacer) ->
          stack = []
          keys = []
          if cycleReplacer == null
            cycleReplacer = (key, value) ->
              if stack[0] == value
                return '[Circular ~]'
              '[Circular ~.' + keys.slice(0, stack.indexOf(value)).join('.') + ']'
              
          (key, value) ->
            if stack.length > 0
              thisPos = stack.indexOf(this)
              if ~thisPos then stack.splice(thisPos + 1) else stack.push(this)
              if ~thisPos then keys.splice(thisPos, Infinity, key) else keys.push(key)
              if ~stack.indexOf(value)
                value = cycleReplacer.call(this, key, value)
            else
              stack.push value
            if replacer == null then value else replacer.call(this, key, value)
        return
  
      log = (level) ->
        msg = if arguments.length == 2 then arguments[1] else toArray(arguments).slice(1)
        result = create('div', { 'class': 'result' }, output(msg))
        elT = addClass(create('p', null, result), typeOf(msg), level)
        firstElement = container.firstChild
        container.insertBefore elT, container.firstChild
        children = container.childNodes
        max = container.parentNode.dataset.limit || 20
        while children.length > max
          container.removeChild children[children.length-2]
        elT
  
      exec = (command) ->
        if !command
          return
        cmd = text(create('div', 'class': 'command'), command)
        level = 'info'
        msg = undefined
        try
          msg = (
            (scope) ->
              eval command
          ).call(scope)
        catch err
          msg = err
          level = 'error'
        elT = log(level, msg)
        elT.insertBefore cmd, elT.childNodes[0]
        elT.scrollTop = elT.scrollHeight
        container.scrollTop = container.scrollHeight
        history.push command
        return
  
      if typeof el == 'string'
        el = document.getElementById(el)
      console = consoles[el]
      if console
        console.cd scope
        return console
      else if !(this instanceof Console)
        if !console
          console = new Console(el, scope)
        return console
      consoles[el] = this
      scope or (scope = window)
      limbo = create('div')
      while node = el.childNodes[0]
        limbo.appendChild node
      container = create('div', 'class': 'console-container')
      inputContainer = create('p', 'class': 'console-input')
      input = create('textarea', row: 1)
      original = 
        className: el.className
        tabIndex: el.tabIndex
      inputContainer.appendChild input
      container.appendChild inputContainer
      addClass(el, 'console').appendChild container
      if el.tabIndex < 0
        el.tabIndex = 0
      listen el, 'focus', ->
        input.focus()
        return
      history = new History
      listen input, 'keydown', (event) ->
        switch event.keyCode
          when 13
            # enter
            event.preventDefault()
            exec @value
            @value = ''
            return false
          when 38
            # up
            if cmd = history.previous()
              input.value = cmd
            event.preventDefault()
            return false
          when 40
            # down
            if cmd = history.next()
              input.value = cmd
            else
              input.value = ''
            event.preventDefault()
            return false
        return
      listen input, 'blur', ->
        history.reset()
        return
      extend this,
        cd: (s) ->
          scope = s
          return
        setDepth: (d)=>
          @depth = d
        log: ->
          @info.apply this, arguments
          return
        info: bind(log, this, 'info')
        warn: bind(log, this, 'warn')
        error: bind(log, this, 'error')
        clear: ->
          `var el`
          prev = inputContainer.previousSibling
          while prev
            elT = prev
            prev = elT.previousSibling
            elT.parentNode.removeChild elT
          return
        destroy: ->
          for k of original
            el[k] = original[k]
          while node = el.childNodes[0]
            el.removeChild node
          while node = limbo.childNodes[0]
            el.appendChild node
          # delete limbo;
          # delete output;
          # delete input;
          # delete original;
          return
  
    create = (tagName, attrs) ->
      el = document.createElement(tagName)
      if attrs
        for k of attrs
          el.setAttribute k, attrs[k]
      i = 2
      while i < arguments.length
        el.appendChild arguments[i]
        ++i
      el
  
    text = (el, text) ->
      if typeof el == 'string' or typeof el == 'number'
        return document.createTextNode(el)
      el.appendChild document.createTextNode(text)
      el
  
    addClass = (el) ->
      `var i`
      classes = []
      i = 1
      while i < arguments.length
        classes = classes.concat(arguments[i].split(/\s+/))
        ++i
      if el.classList
        for i of classes
          el.classList.add classes[i]
      else
        classes = el.className.split(/\s+/).concat(classes)
        el.className = classes.join(' ')
      el
  
    listen = (el, event, callback) ->
      onevent = 'on' + event
      if el.addEventListener
        return el.addEventListener(event, callback, false)
      else if el.attachEvent
        return el.attachEvent(onevent, callback)
      else if onevent of el
        return el[onevent] = callback
      return
  
    extend = (src) ->
      i = 1
      while i < arguments.length
        obj = arguments[i]
        for k of obj
          src[k] = obj[k]
        ++i
      src
  
    toArray = (arr) ->
      Array::slice.call arr
  
    bind = (func, inst) ->
      args = toArray(arguments).slice(2)
      ->
        func.apply inst or this, args.concat(toArray(arguments))
        return
  
    typeOf = (obj) ->
      if Object::toString.call(obj) == '[object Array]'
        'array'
      else if Object::toString.call(obj) == '[object Error]'
        'error'
      else if obj == null
        'null'
      else if obj and obj.nodeType == 1
        'element'
      else
        typeof obj
        
    output = (result, deep=@depth) ->
      `var val`
      `var i`
      type = typeOf(result)
      switch type
        when 'null', 'undefined'
          return create('span', { 'class': type }, text(type))
        when 'array'
          arr = create('ol', 'class': type)
          for i of result
            val = result[i]
            arr.appendChild create('li', null, output(val,deep-1))
          return arr
        when 'object'
          obj = create('dl', 'class': type)
          for k of result
            if !(k of result.__proto__)
              val = if deep == 0 then text(k) else output(result[k], deep-1)
              obj.appendChild create('dt', null, text(k))
              obj.appendChild create('dd', null, val)
          return obj
        when 'element'
          nodeName = result.nodeName.toLowerCase()
          attrs = create('dl')
          open = create('div', { 'class': 'open' }, text(nodeName), attrs)
          close = create('div', { 'class': 'close' }, text(nodeName))
          html = create('div', { 'class': 'content' }, text(result.innerHTML))
          i = 0
          while i < result.attributes.length
            attr = result.attributes[i]
            attrs.appendChild create('dt', null, text(attr.name))
            attrs.appendChild create('dd', null, text(attr.value))
            ++i
          return create('div', { 'class': type }, open, html, close)
        when 'number'
          return create('span', { 'class': type }, text(result.toFixed(2)))
        else
          return create('span', { 'class': type }, text(result.toString()))
      return
  
    Console.log = ->
      return
  
    window.Console = Console
    return
      #
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
      @.jamming = false
      @.jamForce
      ###
      Pylon.on "slider-#{@e.index}:jam", (event)=>
        @jam event.value
      @shifter = 0    
      Pylon.on "slider-#{@e.index}:shift", (event)=>
        @shifter = event.value  
      return
    jam: (forceValue) => # the real world position
      @jamming = true
      @jamForce = forceValue
      ###
      return
    seek: (pursuit) => # the real world position
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
        #debugger
        #if @body.A == "Biggie"
        #  console.log @e.viewAttributes.name,adjust
      else
        adjust = 0
      adjust = @seekerPID.update adjust
      if @jamming
        @force = force + (@jamForce - 128)/255
      else
        @force = force + adjust
      tetraVector = (tetraPosition.vsub @innerSphere.position).unit().scale @body.mass
      @innerSphere.applyForce (tetraVector.scale @force),@innerSphere.position
      @outerSphere.applyForce (tetraVector.scale @force*-1),tetraPosition
      #Pylon.trigger "slider-#{@e.index}:watch",@force
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
            raw: [z*y,y,z]
            cannonLocal: C z*y,y,z
            index: tetrahedralDescription.length
            flip:1
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
      p1.z=2   # lower limit is 2 meters
      p2 = p1.copy().add seen.P 0,0,5
      marker=seen.Shapes.pipe p1,p2,0.3,6
      @avatar.add marker.fill new seen.Material seen.C 20,20,20
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
        angularDamping: 0.1
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
      @.avatar.add @.innerHull = seen.Shapes.tetrahedron().scale(10*@radius * @config.innerRatio).stroke new seen.Material seen.C 20,200,200,200
      @innerHull.fill new seen.Material 'hsla(0,0,0,1)'
      @.innerHull.bake()
      # create seen model for outerHull & it's decorations
      @.outerHull = new seen.Model()
      #@.outerHull.add hull=seen.Shapes.sphere().scale(@radius*10).fill new seen.Material seen.C 200,200,20,200
      @.outerHull.add hull=tetrahedralSphere(4).scale(@radius*10).fill new seen.Material seen.C 200,200,20,200
      @.outerHull.bake()
      tetraNames = ["orange","blue","green","violet"]
      colorHex = ["#FDD459", "#46e1d4","#24C52B","#C31A96"]
      @accessControlPoints (e)->
        e.viewAttributes =
          name: tetraNames[e.index]
          color: colorHex[e.index]

      @accessControlPoints (e)=>
        pInner = e.p.copy().multiply 5*@radius * @config.innerRatio
        pOuter = e.p.copy().multiply 5*@radius
        strut = seen.Shapes.pipe pOuter,pInner,0.1,3
        strut.name = e.viewAttributes.name
        #strutV = seen.Shapes.pipe pOuter,pInner,0.1,3
        #strutV.name = e.viewAttributes.name + '-old'
        e.strut = strut
        #e.strutV = strutV
        rc=seen.Colors.parse e.viewAttributes.color
        @avatar.add strut.fill new seen.Material rc
        rc=seen.Colors.parse e.viewAttributes.color
        rc.a=128
        #@outerHull.add strutV.fill new seen.Material rc
        ###
        el = document.getElementById('sliders')
        #debugger
        what = document.createElement("div")
        what.innerHTML= T.render ()->
          ident = "slider-#{e.index}"
          T.input "##{ident}",type:"range", min:0,max:255,oninput: "Pylon.trigger('#{ident}:jam',this);"
          T.label for: ident,e.viewAttributes.name
          T.input "##{ident}-watch.right",type:"range", min:0,max:255
          T.input "##{ident}-shift.right",type:"range", min:0,max:255, oninput: "Pylon.trigger('#{ident}:shift',this);"
        el.appendChild what
        Pylon.on "slider-#{e.index}:watch",(f)=>
          el=document.getElementById "slider-#{e.index}-watch"
          el.value = f*7-128
          return
        ###
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
      @accessControlPoints (e)=>
        # vio,vos,vis vector sides of triangles
        # l == local frame
        # w == world frame
        # wi inner, wo outer, ws strut
        vio=  (wo=@innerSphere.position).vsub (wi=@outerSphere.position )
        ls= e.cannonLocal.unit().scale @radius
        ws= @outerSphere.pointToWorldFrame ls
        vos = wo.vsub ws
        vis= wi.clone().vsub ws
        perp = vis.cross vos
        perp.normalize()
        visl = vis.length();vosl=vos.length();viol=vio.length()
        top =  visl*visl + vosl*vosl - viol*viol
        bottom = 2* visl * vosl
        angle = Math.acos (top/bottom)
        obtuse = viol> vosl+visl
        if obtuse
          if  angle < Math.PI
            angle = Math.PI*2-angle
        else
          if angle > Math.PI
            angle = Math.PI*2-angle
            
        #what does angle do
        angle = 2*Math.PI*e.tetraForcer.shifter/255 if e.tetraForcer.shifter
        r = seen.Quaternion.axisAngle perp.x,perp.y,perp.z,angle
        size = @radius*5*(1-@config.innerRatio)
        #rotator = rotator.multiply rotation
        #debugger
        e.strut.reset()
        r= r.multiply(rotation).toMatrix() #if e.index == 3
        #e.strut.translate -ls.x*10,-ls.y*10,-ls.z*10
        e.strut.transform r
        e.strut.translate wo.x*10,wo.y*10,wo.z*10
        #e.strut.scale size
        #e.pipe.translate t.x,t.y,t.z
        #console.log e.pipe
        return
      return
    clear: ()=>
      @accessControlPoints (e)->
        e.tetraForcer.shifter=0
        e.tetraForcer.jamming=false
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
    if t>dropTime & balls.length <14
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
      when 'c'
        allBall (b)->
          b.clear()
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
class  index extends celarientemplate
  #
  # section storyHeadMatter
  #
  storyHeadMatter: ->
    T.script src:"http://seenjs.io/dist/latest/seen.min.js"
    T.script src:"draft/peacefare/rollerball/cannon.js"
    T.script src:"draft/peacefare/rollerball/pid.js"
    T.script src:src="//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.7.1/coffee-script.min.js"
    T.script type:"text/coffeescript", """

  """
    T.style type:"text/css",""".console {
  background: #fff;
  color: #000;
  padding: 0;
  position: relative;
}
.console * {
  border: 0;
  font: normal 14px/1.3 Consolas,'Andale Mono','Courier New',Courier,monospace;
  margin: 0;
  outline: 0;
  padding: 0;
}
.console textarea {
  background: transparent;
  color: #000;
  display: block;
  overflow: hidden;
  resize: none;
  vertical-align: middle;
  width: 100%;
  word-wrap: normal;
}
.console-container {
  max-height: 100%;
  overflow: auto;
}
.console-container span.string {
  color: #c00;
}
.console-container span.string::before,
.console-container span.string::after {
  color: #333;
  content: '"';
}
.console-container span.number {
  color: #00f;
}
.console-container span.null,
.console-container span.undefined {
  color: #999;
}
.console-container ol.array {
 display: inline-block;
}
.console-container ol.array::before {
  color: #999;
  content: '[';
}
.console-container ol.array::after {
  color: #999;
  content: ']';
}
.console-container ol.array li {
  display: inline-block;
}
.console-container ol.array li::after {
  color: #999;
  content: ',';
}
.console-container ol.array li:last-child::after {
  content: none;
}
.console-container dl.object::before {
  color: #000;
  content: '{';
}
.console-container dl.object::after {
  color: #000;
  content: '}';
  margin-left: 0.5em;
}
.console-container dl {
  display: inline-block;
}
.console-container dl.object dt, .console-container dl.object dd {
  display: inline-block;
}
.console-container dl.object dt {
  color: #909;
  margin-left: 0.5em;
}
.console-container dl.object dt::after {
  color: #000;
  content: ':';
  margin-right: 0.25em;
}
.console-container dl.object dd::after {
  content: ',';
}
.console-container dl.object dd:last-child::after {
  content: none;
}
.console-container div.element div.open,
.console-container div.element div.close {
  color: #909;
  display: inline;
}
.console-container div.element div.open::before {
  content: '<';
}
.console-container div.element div.close::before {
  content: '</';
}
.console-container div.element div.open::after,
.console-container div.element div.close::after {
  content: '>';
}
.console-container div.element div.content {
  display: none;
}
.console-container div.element dl,
.console-container div.element dt,
.console-container div.element dd {
  display: inline;
}
.console-container div.element dt {
  color: #c00;
  margin-left: 0.5em;
}
.console-container div.element dt::after {
  content: '=';
}
.console-container div.element dd {
  color: #00f;
}
.console-container div.element dd::before,
.console-container div.element dd::after {
  color: #c00;
  content: '"';
}
.console-container p {
  padding-left: 15px;
  position: relative;
}
.console-container p::before {
  color: #ccc;
  content: '>';
  left: 0;
  position: absolute;
  text-align: center;
  top: 0;
  vertical-align: middle;
  width: 15px;
}
.console-container p.console-input::before {
  color: #39f;
}
.console-container p div.command {
  color: #39f;
  white-space: pre;
}
.console-container p.error div.result {
  color: #f00;
}
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
  footer: =>
    T.div "#console0",'data-limit':10
    T.coffeescript Gravitas
    return
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
      T.h3 => "The celarien's tools of the spiritual bodyguard"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.h3 "The controllers of the RollerBall"
    T.div "#bloviation.contents", =>
      T.form "#sliders.flex-container"
      T.canvas "#seen-canvas",width:400, height:400 
      #T.p => T.raw "single slider for each actuator"
      T.p => T.raw "Press hjkl to change where these rollerballs take down an attacker."
      T.p => "Rotate the view with click and drag.  Zoom with fingers or mouse wheel."
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
db[id="celarienpeacefarerollerball-control"] =
  title: "rollerball-control"
  slug: "rollerball-control"
  category: "peacefare"
  site: "597aea40d3cfff7cc5f926f0"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-04-25T21:53:41.402Z"
  lastEdited: "2018-04-25T21:53:41.403Z"
  published: "2018-04-25T21:53:41.403Z"
  embargo: "2018-04-25T21:53:41.403Z"
  captureDate: "2018-04-25T21:53:41.403Z"
  TimeStamp: 1524693221403
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarienpeacefarerollerball-control"
  name: "rollerball-control"
#
#end of story