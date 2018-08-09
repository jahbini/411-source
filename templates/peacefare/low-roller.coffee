###
#-------- class start
#
# lowRoller -- internally controlled sphere
#
###

demoMode = true
Gravitas = ->
  window.demo = true
  #include constraint2.coffee
  #include console.coffee
  #include linear-motor.coffee
  
#Ignore = ->
  
  window.onkeypress= (event)->
    switch event.key
      when "."
        window.debugForce = true
  
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
renderer = class  index extends celarientemplate
  #
  # section storyHeadMatter
  #
  storyHeadMatter: ->
    T.script src:"https://aframe.io/releases/0.8.0/aframe.js"
    T.script src:"draft/peacefare/rollerball-cog/aframe-physics-system.js"
    #T.script src:"assets/seen.min.js"
    #T.script src:"draft/peacefare/low-roller/cannon.js"
    T.script src:"draft/peacefare/rollerball/pid.js"
    T.script src:"https://cdnjs.cloudflare.com/ajax/libs/coffee-script/1.7.1/coffee-script.min.js"
    T.script src:"https://unpkg.com/aframe-environment-component/dist/aframe-environment-component.min.js"
    T.script src:"https://unpkg.com/aframe-arrow-component@1.0.0/index.js"
    T.style type:"text/css","""
a-scene { height: 300px; width: 600px; }
#include console.css
"""
  lowRollerDefinition: ->
    ###
    Start of lowroller component
    ###
    T.coffeescript Gravitas
    T.coffeescript  ->
      if !window.demo
        consolex=Console "console0",window
        window.consol = consolex
        window.debugForce = false
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
      window.bind1=bind #hack
      setEverything = (e,attributes,hash={}) ->
        for a,v of attributes
          e.setAttribute a,v
        for a,v of hash
          e[a] = v
        e.updateProperties() if e.updateProperties?
        return
      class TetraForcer
        MINFORCE = 15
        constructor: (body,@e)->
          @tetraPoint = @e.cannonLocal
          @outie = body.el
          @innie = body.innie
          @seekerPID = new PID -100,1,-0.1, 1/60.0
          #@seekerPID = new PID 0,0,0, 1/60.0
          @seekerPID.setTarget = 0
          return
          
        seek: (pursuit) => # the real world position
          pursuit.z = (radius=@outie.getAttribute('geometry').radius) * 2  
          seekVector = pursuit.vsub @outie.body.position
          seekPosition = @outie.body.position.vadd seekVector.unit().scale radius *.8
          tetraPosition = @outie.body.pointToWorldFrame @tetraPoint
          force = MINFORCE
          @tetraToPursuit = pursuit.distanceTo(tetraPosition)
          @tetraToPursuit = seekPosition.distanceTo(tetraPosition)
          @toInnie =@innie.body.position.distanceTo(seekPosition)
          @innieToPursuit = pursuit.distanceTo @innie.body.position
          @tetraToInnie = tetraPosition.distanceTo @innie.body.position
          if @tetraToPursuit < @tetraToInnie
            adjust = @toInnie
          else
            adjust = 0
          #adjust = @seekerPID.update adjust
          adjust = 0
          if @jamming
            @force = force + (@jamForce - 128)/255
          else
            @force = force + adjust
          tetraPosition = @outie.body.position
          @force= MINFORCE
          tetraVector = (tetraPosition.vsub @innie.body.position).unit().scale @innie.body.mass/10
          @innie.body.applyImpulse (tetraVector.scale @force),@innie.body.position
          @outie.body.applyImpulse (tetraVector.scale @force*-1),tetraPosition
          return


      innieCounter = 0
      innieID = ->
        "innie__#{++innieCounter}"
      dLay = (f)->
        setTimeout f,0
      V2A = (position) ->
        "#{position.x} #{position.y} #{position.z}"
      C = (x=0,y=0,z=0)-> new CANNON.Vec3 x,y,z
      AFRAME.registerComponent 'lowroller',  
        schema:
          inner: type: 'number',default: 9
          outer: type: 'number',default:1
          pursuit: type: 'vec2', default: {x:0, y:0}
        controlPoints: []
        ###
        iterate over the four tetrahedral control points
        ###
        accessControlPoints: (f) ->
          for element in @controlPoints
            f element
        ###
        setPursuit aims the low-roller at this xy destination
        ###
        setPursuit: (p)->
          @pursuit = new CANNON.Vec3 p.x,@radius , p.y
          if this.el.body
            this.el.body.pursuit = @pursuit
            this.el.body.radius = @radius
          return
        ###
        Initialization
        ###
        init: ->
          @initRuntime = true
          tetrahedralDescription=[]
          do -> 
            r=[ 1,-1]
            for z in r
              for y in r
                tetrahedralDescription.push
                  p:  new THREE.Vector3 z*y,y,z
                  normed:  (new THREE.Vector3 z*y,y,z).normalize()
                  raw: [z*y,y,z]
                  cannonLocal: (C z*y,y,z).unit()
                  index: tetrahedralDescription.length
                  flip:1
            return
          ###
          tetrahedron init
          ###
          @.tetrahedralDescription=tetrahedralDescription
          data = @.data
          @setPursuit @.data.pursuit 
          radius = @.el.components.geometry.data.radius
          scale = @.el.components.geometry.data.scale
          @totalMass = data.inner + data.outer
          position = @.el.components.position.data
          @el.addEventListener 'body-loaded', (event) =>
            #debugger
            body = event.currentTarget.body
            body.velocity.set 0,0,0
            body.angularVelocity.set 0,0,0
            body.quaternion = body.initQuaternion
            body.pursuit = @pursuit
            body.radius = @.el.components.geometry.data.radius
            body.tetraPoints = tetrahedralDescription
            body.updateProperties()
            return
          ###
          Outer sphere physics attributes
          ###
          @el.setAttribute 'dynamic-body',"shape:'sphere'; sphereRadius:#{radius}; mass: #{data.outer}; linearDamping: 0.5; angularDamping: 0.91;"
          @el.setAttribute "geometry", "primitive: sphere; radius: #{radius}"
          ###
          create inner sphere
          ###
          innie = document.createElement 'a-sphere'
          innie.id = innieID()
          @myInnieID = innieCounter
          innie.setAttribute 'radius',"#{data.outer/@totalMass}"
          innie.setAttribute "position",position
          innie.setAttribute 'dynamic-body', "shape:'sphere'; sphereRadius: #{data.outer/@totalMass}; mass: #{data.inner}; linearDamping: 0.5; angularDamping: 0.5"
          @.innie = innie
          @innie.addEventListener 'body-loaded', (event) =>
            #debugger
            body = event.currentTarget.body
            body.collisionResponse =  true
            body.collisionFilterGroup = 2
            body.collisionFilterMask = 1
            body.updateProperties();
            return
          @.el.parentElement.insertBefore innie, @.el
          
          ###
          create tetrahedron
          ###
          #tet = document.createElement 'a-tetrahedron'
          #tet.setAttribute 'physics',"mass:0; shape:'sphere'; sphereRadius: 0.1; collisionResponse: false"
          #tet.setAttribute 'material','wireframe:true'
          #tet.setAttribute 'radius',"#{radius}"
          #@.el.appendChild tet
          #@.tet = tet
          ###
          create tetrahedral support points
          ###
          
          @controlPoints = for v in tetrahedralDescription
            Object.assign {}, v
          @myPoints = @accessControlPoints (e)=>
            pivotPoint = V2A e.normed.multiplyScalar radius
            mPivotPoint = V2A e.normed.multiplyScalar -radius
            p2 = V2A e.normed.multiplyScalar -radius
            return
          # build up the force vectors on the anchor points
          colors = ["#fff","#f88","#8F8","#88F"]
          @accessControlPoints (e)=>
            iVector = document.createElement 'a-entity'
            iVector.setAttribute 'arrow',"direction: 1 1 1; length:1; color: #{colors[e.index]}"
            iVector.id = "#{@innie.id}__innieForce__#{e.index}"
            @.el.parentElement.insertBefore iVector,@.el
            iVector = document.createElement 'a-entity'
            iVector.setAttribute 'arrow',"direction: 1 1 1; length:1; color: #{colors[e.index]}"
            iVector.id = "#{@innie.id}__outieForce__#{e.index}"
            @.el.parentElement.insertBefore iVector,@.el
            
          #  e.tetraForcer = new TetraForcer @, e
          @el.setAttribute "constraint2","target: ##{@innie.id}; minForce:15; type: tetraForcer;"
          #@el.setAttribute "constraint","target: ##{@innie.id}; maxForce:1.0e4; type: distance;"
          @tockCount = 20
          console.log "INIT",@totalMass,radius
          return 

        update: ->
          @setPursuit @.data.pursuit
          console.log "UPDATE"
          return
        remove: -> console.log "REMOVE"; return
        pause: -> console.log "PAUSE"; return
        play: ->
          console.log "PLAY"
          return
        ###
        Tick updated on each physics state
        ###
        tick: ->
          return unless @innie.body && @el.body
          if @initRuntime
            @initRuntime = false
          #console.log "TICK",@el.body.velocity,@innie.body.velocity
          return  #jah
        tock: ->
          if @tockCount == 0
            return
          @tockCount--
          try
            v1 = @innie.body.velocity
            v2 = @el.body.velocity
            v3 = @myPoints[0].body.velocity
            #console.log v2,v1,v3
              
          catch
          return
  # 
  # section html
  # 
  # 
  # section celarien_body
  # 
  # 
  # section cover
  # 
  # 
  # section footer 
  footer: =>
    T.div "#console0.left",visible:false,'data-limit':100
    return
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
    T.aside "#sidebar.o-grid__cell.o-grid__cell--width-20.p2.bg-darken-2", style: "min-width:240"
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
    if useAll = demoMode
      cameraPos = "0 1.6 5"
    else
      cameraPos = "0 1 3"
    @footer()
    @lowRollerDefinition()
    T.div ".container.right",=>
      T.tag "a-scene",embedded:true,physics:'debug: false; driver: local; gravity: -9.6; friction: 0.10; restitution: 0.300;',=>
        T.tag "a-entity", physics:'mass:0;', position: cameraPos, rotation:"0 0 0",=>
          T.tag "a-camera", physics: 'mass:0;','universal-controls':true, 'body-static':true, 'mouse-cursor':true, "look-controls":"enabled:true", "wasd-controls":"enabled:true",->
            T.tag "a-cursor"
        T.tag "a-sphere",  "#outie", lowroller: "inner:4;outer:1;pursuit: 2,0;", position:"-2 6 -10", radius:"1", material:"color:#EFff5E; transparent:true; opacity:0.3;"
        if useAll
          T.tag "a-sphere",  'dynamic-body':'', lowroller: "inner:9;outer:1;", position:"-2 1.25 -15", radius:"1.25", material:"color:#EF005E; transparent:true; opacity:0.3;"
          T.tag "a-sphere",  'dynamic-body':'', lowroller: "inner:4;outer:1;pursuit: 2.2,0;", position:"-3 10.75 0", radius:"0.75", material:"color:#EFff5E; transparent:true; opacity:0.3;"
          T.tag "a-sphere",  'dynamic-body':'', lowroller: "inner:4;outer:1;pursuit: 2,0;", position:"-4 0.75 0", radius:"0.75", material:"color:#EFff5E; transparent:true; opacity:0.3;"
          T.tag "a-sphere",  'dynamic-body':'', lowroller: "inner:4;outer:1;pursuit: 2.2,0;", position:"-5 0.75 -4", radius:"0.75", material:"color:#EFff5E; transparent:true; opacity:0.3;"
          T.tag "a-sphere",  'dynamic-body':'', lowroller: "inner:4;outer:1;pursuit: 2,0;", position:"-2 0.75 -2", radius:"0.75", material:"color:#EFff5E; transparent:true; opacity:0.3;"
          T.tag "a-sphere", 'dynamic-body':'', position:"0 .25 -2.2", radius:".25",  material:"color:#EF005E; transparent:true; opacity:0.3;"
          T.tag "a-box", 'dynamic-body':'', position:"0 4.5 -5", rotation:"0 45 0", width:"2", height:"2", depth:"2", color:"#4CC3D9"
          T.tag "a-box", 'static-body': '', position:"-10 3.5 -7", rotation:"0 45 0", width:"0.1", height:"1.0", depth:"0.1", color:"#22CC22"
          T.tag "a-box", 'static-body': '', position:"2 3.5 -5", rotation:"0 45 0", width:"0.1", height:"1.0", depth:"0.1", color:"#4CC3D9"
          T.tag "a-box", 'static-body': '', position:"-2 3.5 -5", rotation:"0 45 0", width:"0.1", height:"1.0", depth:"0.1", color:"#4CC3D9"
          T.tag "a-box", 'static-body': '', position:"-4 3.5 -3", rotation:"0 45 0", width:"0.1", height:"1.0", depth:"0.1", color:"#4CC3D9"
          T.tag "a-box", 'static-body': '', position:"8 3.5 -10", rotation:"0 45 0", width:"0.1", height:"1.0", depth:"0.1", color:"#4CC3D9"
          T.tag "a-cylinder", 'static-body': '', position:"-1 0.75 -3", radius:"0.5", height:"1.5", color:"#FFC65D"
          #T.tag "a-plane", 'static-body':'', position:"3 1.5 -4", rotation:"0 45 30", width:"4", height:"5", color:"#987654"
          T.tag "a-sky", color:"#cceecc"
          T.tag "a-box", position: "-2 0 0" ,width: "0.1", height: "0.1" , depth:"0.1", color: "yellow"
          T.tag "a-box", position: "2 0 0" ,width: "0.1", height: "0.1" , depth:"0.1", color: "yellow"

          for x in [-3..3]
            for y in [-5..-1]
              T.tag "a-box", position: "#{x} 0 #{y}" ,width: "0.1", height: "0.1" , depth:"0.1", color: "green"
          T.tag "a-entity", environment:"preset: forest; dressingAmount: 500"
          
        T.tag "a-plane", 'static-body':'', position:"0  -0.01 -4", rotation:"-90 0 0", width:"40", height:"50", color:"#7BC8A4"
        T.tag "a-sphere", "#marker", position: "0 0 0", radius: "0.1", color: "black"
        T.tag "a-sphere", "#sucker", position: "2 0 0", radius: "0.1", color: "white"
  

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
      #T.canvas "#seen-canvas",width:400, height:400 
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
db[id="celarien/peacefare/low-roller"] =
  title: "low-roller"
  slug: "low-roller"
  category: "peacefare"
  site: "celarien"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-06-29T01:37:44.693Z"
  lastEdited: "2018-06-29T01:37:44.694Z"
  published: "2018-06-29T01:37:44.694Z"
  embargo: "2018-06-29T01:37:44.694Z"
  captureDate: "2018-06-29T01:37:44.694Z"
  TimeStamp: 1530236264694
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarien/peacefare/low-roller"
  name: "low-roller"
#
#end of story