### 
var CANNON = require('cannon'); 
###
class PID
  ###
  the PID style of controller is intended to track a quantity from the real world as detected by some sensor.
  The sensor is assumed to be reliable as possible, consistent and acccurate.
  the output of the controller is a single quantity that controls a single output device.
  The output device is related in some fashion to changes in the real world that affect the sensor.
  A PID controller ses the input values to compte an output variable by looking at three internally 
  computed quantities.
  1) the Proportial component, which simply is related to "How far away from our goal are we?"
  2) the Integral component, which is related to "How far have we come to our goal?"
  3) the Differential component, which asks "are we taking big steps, or tiny ones?"
  ###
  constructor: (proportionalParm, integrationParm, derivativeParm, dt) ->
    if (typeof proportionalParm == 'object')
      options = proportionalParm
      proportionalParm = options.proportionalParm
      integrationParm = options.integrationParm
      derivativeParm = options.derivativeParm
      dt = options.dt || 0
      integrationLimit = options.integrationLimit
  
    # PID constants
    @proportionalParm = if typeof proportionalParm == 'number' then proportionalParm else 1
    @integrationParm = integrationParm || 0
    @derivativeParm = derivativeParm || 0
  
    # Interval of time between two updates
    # If not set, it will be automatically calculated
    @dt = dt || 0
  
    # Maximum absolute value of sumDelta
    @integrationLimit = integrationLimit || 0
    @sumDelta  = 0
    @lastDelta = 0
    @setTarget 0 # default value, can be modified with .setTarget
    return
  
  setTarget: (@target) ->
    @lastTime = Date.now()  # used only if dt is not explicit
    return
  
  update: (@currentValue) -> 
    # Calculate dt
    dt = @dt
    if !dt 
      currentTime = Date.now()
      dt = (currentTime - @lastTime) / 1000 # in seconds
      @lastTime = currentTime
    if (typeof dt != 'number' || dt == 0) 
      dt = 1
 
    delta = @target - @currentValue  #used as the Proportional factor
    
    @sumDelta = @sumDelta + delta*dt  #used as the Integral factor
    if 0< @integrationLimit < Math.abs(@sumDelta) #if there is an integration limit, check it
      sumSign = if @sumDelta > 0 then 1 else -1
      @sumDelta = sumSign * @integrationLimit  # activate the caller's failsafe quantity

    dDelta = (delta - @lastDelta)/dt # used as the Derivitive factor
    @lastDelta = delta
    return (@proportionalParm*delta) +
      (@integrationParm * @sumDelta) +
      (@derivativeParm * dDelta)
  
  reset:() ->
    @sumDelta  = 0
    @lastDelta = 0
    @setTarget 0
    return


###
* Convert a local body point to world frame.
* @method pointToWorldFrame
* @param  {Vec3} localPoint
* @param  {Vec3} result
* @return {Vec3}
###

pointToWorldFrame= (body,localPoint,result= new CANNON.Vec3())->
  body.quaternion.vmult localPoint,result
  result.vadd body.position,result
  result

###*
# A tetraForcer, connecting two bodies by four tetrahedral anchors.
#
# @class TetraForcer
# @constructor
# @param {Body} outie
# @param {Body} innie
# @param {Object} [options]
###
class TetraForcer
  constructor: (@outie, @innie, options={}) ->
    ###*
    # Proportional, Integral, Differential parameters
    # @property pid
    # @type {object}
    ###
    p=options.pid || {}
    p.p = p.p || -100
    p.i = p.i || 1
    p.d = p.d || -0.1
    p.rate = p.rate || 1/60.0
    @pID = new PID p
    ###*
    # min force
    # resting force
    # @property minForce
    # @type {number}
    ###
    @minForce = options.minForce || 10
    # springs and TetraForcers do not have equations, they add forces directly 
    @equations = []
    return
  ###*
  # Set the anchor point on body A, using world coordinates.
  # @method setWorldAnchorA
  # @param {Vec3} worldAnchorA
  ###
  setWorldAnchorA: (worldAnchorA) ->
    @outie.pointToLocalFrame worldAnchorA, @localAnchorA
    return
  ###*
  # Set the anchor point on body B, using world coordinates.
  # @method setWorldAnchorB
  # @param {Vec3} worldAnchorB
  ###
  setWorldAnchorB: (worldAnchorB) ->
    @innie.pointToLocalFrame worldAnchorB, @localAnchorB
    return
  ###*
  # Get the anchor point on body A, in world coordinates.
  # @method getWorldAnchorA
  # @param {Vec3} result The vector to store the result in.
  ###
  getWorldAnchorA: (result) ->
   pointToWorldFrame @outie, @localAnchorA, result
   return
  ###*
  # Get the anchor point on body B, in world coordinates.
  # @method getWorldAnchorB
  # @param {Vec3} result The vector to store the result in.
  ###
  getWorldAnchorB: (result) ->
    pointToWorldFrame  @innie,@localAnchorB, result
    return
  Vec3 = CANNON.Vec3
  pursuit = new Vec3()
  seekVector = new Vec3()
  seekPosition = new Vec3()
  tetraPosition = new Vec3()
  tetraToPursuit = new Vec3()
  toInnie = new Vec3()
  innieToPursuit = new Vec3()
  tetraToInnie = new Vec3()
  applyForce_ri = new Vec3()
  applyForce_rj = new Vec3()
  applyForce_ri_x_f = new Vec3()
  applyForce_rj_x_f = new Vec3()
  applyForce_tmp = new Vec3()
  applyForce_pursuePoint = new Vec3()
  applyForce_worldAnchorA = new Vec3()
  applyForce_worldAnchorB = new Vec3()
  outieToInnie = new Vec3()
  nullVector = nullPoint = new Vec3()
    
  ###*
  # Apply the linearMotor force to the connected bodies.
  # @method applyForce
  ###
  update: ->
    dt = 0.0166
    # where is the pursuit in local coordinates?
    # the low-roller centric position we want to place innie's body
    # must be within outie (outie)
    outieLimitW = @outie.radius * 0.9     #exactly where is on this hull
    seekPositionW = @outie.position.vadd ( (@outie.pursuit.vsub @outie.position).unit().scale outieLimitW )
    seekPositionL = @outie.pointToLocalFrame seekPositionW
    inf=document.querySelector "#marker"
    inf.setAttribute "position",seekPositionW
    if @type=='tetraPositioner'  # HACK JAH
      # we move the innie as if it were a static component
      # and apply innie's gravitational force to outie's magic innie position
      @innie.position.copy @outie.pointToWorldFrame seekPositionL
      @innie.velocity.copy @innie.initVelocity
      @outie.applyForce new Vec3(0,-9.6*@innie.mass,0.1),@innie.position.vsub @outie.position
      return
      
    outieToInnieLimitR = (@outie.position.distanceTo @innie.position) /@outie.radius
    innieNextW = @innie.position.vadd @innie.velocity.scale dt      #where will innie be?
    outieToInnieNextR = (@outie.position.distanceTo innieNextW) /@outie.radius
    innieNextL = @outie.pointToLocalFrame innieNextW
    innieStopForce = @innie.velocity.scale -@innie.mass*dt  # what force does it take to stop it?
    
    # where is innie in local coordinates?
    innieLocalPosition = @outie.pointToLocalFrame @innie.position
    innieToSeekDistance = innieLocalPosition.distanceTo seekPositionL
      
    for tetraStruct in @outie.tetraPoints
      force = @minForce * @innie.mass
      tet = tetraStruct.cannonLocal.scale @outie.radius
      tetW = pointToWorldFrame @outie, tet
      innieNullPointW = pointToWorldFrame @innie, nullPoint
      tetraVector = (tetW.vsub @innie.position)
      tetraLength = tetraVector.length() # - outieLimitW
      force = force * tetraLength 
      tetToSeekDistance = tetW.distanceTo seekPositionW
      if tetToSeekDistance < innieToSeekDistance
        adjust = 10*@innie.mass 
      else
        adjust = -10*@innie.mass
      force += adjust
      direction=tetraVector.unit()
      @outie.applyForce (tetraVector.unit().scale -force), tetW.vsub @outie.position
      @innie.applyForce (tetraVector.unit().scale force),innieNullPointW.vsub @innie.position
      innieID=@innie.el.id
      inf=document.querySelector "##{innieID}__innieForce__#{tetraStruct.index}"
      return if !inf
      inf.setAttribute "position",@innie.position 
      inf.setAttribute "arrow", "direction: #{direction.x} #{direction.y} #{direction.z}; length: #{force/10}"
      otf=document.querySelector "##{innieID}__outieForce__#{tetraStruct.index}"
      otf.setAttribute "position",tetW
      otf.setAttribute "arrow", "direction: #{-1 * direction.x} #{-1*direction.y} #{-1 * direction.z}; length: #{force/10}"
      
    return
    
###
# Register the component with the A-Frame system
# decode and pass options along
#
###
AFRAME.registerComponent('tetra-motor',
  multiple: false
  schema:
    type:
      oneOf: [
        'tetraPositioner'
        'tetraForcer'
      ]
    target: type: 'selector'
    minForce:
      default: 10
      min: 0
    maxForce:
      default: 1e6
      min: 0
    collideConnected: default: true
    wakeUpBodies: default: true
    restLength:
      type: 'number'
      default: 0
    localAnchor:
      type: 'vec3'
      default:
        x: 0
        y: 0
        z: 0
     localTarget:
      type: 'vec3'
      default:
        x: 0
        y: 0
        z: 0
     
  init: ->
    @system = @el.sceneEl.systems.physics
    @constraint = null
    return
  remove: ->
    if !@constraint
      return
    @system.removeConstraint @constraint
    @constraint = null
    return
  update: ->
    el = @el
    data = @data
    @remove()
    if !el.body or !data.target?.body
      (if el.body then data.target else el).addEventListener 'body-loaded', @update.bind(this, {})
      return
    @constraint = @createConstraint()
    @system.addConstraint @constraint
    return
  createConstraint: ->
    constraint = undefined
    data = @data
    constraint = undefined
    data.type = 'tetraForcer'
    switch data.type
      when 'tetraForcer' || 'tetraPositioner'
        lA = @data.localAnchor
        lB = @data.localTarget
        constraint = new (TetraForcer)(@el.body, data.target.body,
          pid: @data.pid
          minForce: @data.minForce)
        constraint.type = 'tetraMotor'
      else
        throw new Error('[constraint] Unexpected type: ' + data.type)
    constraint
)

setEverything = (e,attributes,hash={}) ->
  for a,v of attributes
    e.setAttribute a,v
  for a,v of hash
    e[a] = v
  e.updateProperties() if e.updateProperties?
  return
class TetraForcer2
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
    @el.setAttribute "tetra-motor","target: ##{@innie.id}; minForce:15; type: tetraForcer;"
    #@el.setAttribute "constraint","target: ##{@innie.id}; maxForce:1.0e4; type: distance;"
    @tockCount = 20
    console.log "INIT",@totalMass,radius
    debugger
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
