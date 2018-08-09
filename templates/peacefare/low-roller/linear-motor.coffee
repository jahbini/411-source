
###
# Linear motor constraint
###


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
    #if window.demo # HACK JAH
    #  @innie.position.copy @outie.pointToWorldFrame seekPositionL
    #  @innie.velocity.copy @innie.initVelocity
    #  @outie.applyForce new Vec3(0,-9.6*@innie.mass,0.1),@innie.position.vsub @outie.position
    #  return
      
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
      debugger
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
      inf.setAttribute "position",@innie.position 
      inf.setAttribute "arrow", "direction: #{direction.x} #{direction.y} #{direction.z}; length: #{force/10}"
      otf=document.querySelector "##{innieID}__outieForce__#{tetraStruct.index}"
      otf.setAttribute "position",tetW
      otf.setAttribute "arrow", "direction: #{-1 * direction.x} #{-1*direction.y} #{-1 * direction.z}; length: #{force/10}"
      
    return
#module.exports = LinearMotor

###
# Spring constraint
###


###*
# A spring, connecting two bodies.
#
# @class Sprint
# @constructor
# @param {Body} bodyA
# @param {Body} bodyB
# @param {Object} [options]
# @param {number} [options.restLength]   A number > 0. Default: 1
# @param {number} [options.stiffness]    A number >= 0. Default: 100
# @param {number} [options.damping]      A number >= 0. Default: 1
# @param {Vec3}  [options.worldAnchorA] Where to hook the linearMotor to body A, in world coordinates.
# @param {Vec3}  [options.worldAnchorB]
# @param {Vec3}  [options.localAnchorA] Where to hook the linearMotor to body A, in local body coordinates.
# @param {Vec3}  [options.localAnchorB]
###
class Spring
  constructor: (@bodyA, @bodyB, options={}) ->
    ###*
    # Rest length of the spring.
    # @property restLength
    # @type {number}
    ###
    @restLength = if typeof options.restLength == 'number' then options.restLength else 1
    ###*
    # Stiffness of the spring
    # @property stiffness
    # @type {number}
    ###
    @stiffness = options.stiffness || 100
    ###*
    # Damping of the spring.
    # @property damping
    # @type {number}
    ###
    @damping = options.damping or 1
    ###*
    # Anchor for bodyA in local bodyA coordinates.
    # @property localAnchorA
    # @type {Vec3}
    ###
    @localAnchorA = new Vec3()
    ###*
    # Anchor for bodyB in local bodyB coordinates.
    # @property localAnchorB
    # @type {Vec3}
    ###
    @localAnchorB = new Vec3()
    if options.localAnchorA
      @localAnchorA.copy options.localAnchorA
    if options.localAnchorB
      @localAnchorB.copy options.localAnchorB
    if options.worldAnchorA
      @setWorldAnchorA options.worldAnchorA
    if options.worldAnchorB
      @setWorldAnchorB options.worldAnchorB
    # springs and linear motors do not have equations, they add forces directly 
    @equations = []
    return
  ###*
  # Set the anchor point on body A, using world coordinates.
  # @method setWorldAnchorA
  # @param {Vec3} worldAnchorA
  ###
  setWorldAnchorA: (worldAnchorA) ->
    @bodyA.pointToLocalFrame worldAnchorA, @localAnchorA
    return
  ###*
  # Set the anchor point on body B, using world coordinates.
  # @method setWorldAnchorB
  # @param {Vec3} worldAnchorB
  ###
  setWorldAnchorB: (worldAnchorB) ->
    @bodyB.pointToLocalFrame worldAnchorB, @localAnchorB
    return
  ###*
  # Get the anchor point on body A, in world coordinates.
  # @method getWorldAnchorA
  # @param {Vec3} result The vector to store the result in.
  ###
  getWorldAnchorA: (result) ->
   pointToWorldFrame @bodyA, @localAnchorA, result
   return
  ###*
  # Get the anchor point on body B, in world coordinates.
  # @method getWorldAnchorB
  # @param {Vec3} result The vector to store the result in.
  ###
  getWorldAnchorB: (result) ->
    pointToWorldFrame  @bodyB,@localAnchorB, result
    return
  Vec3 = CANNON.Vec3
  applyForce_r = new Vec3()
  applyForce_r_unit = new Vec3()
  applyForce_u = new Vec3()
  applyForce_f = new Vec3()
  applyForce_f_old = new Vec3()
  applyForce_worldAnchorA = new Vec3()
  applyForce_worldAnchorB = new Vec3()
  applyForce_ri = new Vec3()
  applyForce_rj = new Vec3()
  applyForce_ri_x_f = new Vec3()
  applyForce_rj_x_f = new Vec3()
  applyForce_tmp = new Vec3()
  ###*
  # Apply the spring force to the connected bodies.
  # @method applyForce
  ###
  update: ->
    k = @stiffness
    d = @damping
    l = @restLength
    bodyA = @bodyA
    bodyB = @bodyB
    r = applyForce_r
    r_unit = applyForce_r_unit
    u = applyForce_u
    f = applyForce_f
    tmp = applyForce_tmp
    ri = applyForce_ri
    rj = applyForce_rj
    ri_x_f = applyForce_ri_x_f
    rj_x_f = applyForce_rj_x_f
    # Get world anchors
    worldAnchorA = applyForce_worldAnchorA
    worldAnchorB = applyForce_worldAnchorB
    @getWorldAnchorA worldAnchorA
    @getWorldAnchorB worldAnchorB
    # Get offset points
    worldAnchorA.vsub bodyA.position, ri
    worldAnchorB.vsub bodyB.position, rj
    # Compute distance vector between world anchor points
    worldAnchorB.vsub worldAnchorA, r
    # rlen: the current extension of the spring (motor)
    rlen = r.length()
    r_unit.copy r
    r_unit.normalize()
    
    # Compute relative velocity of the anchor points, u
    bodyB.velocity.vsub bodyA.velocity, u
    # Add rotational velocity
    bodyB.angularVelocity.cross rj, tmp
    u.vadd tmp, u
    bodyA.angularVelocity.cross ri, tmp
    u.vsub tmp, u
    # F = - k * ( x - L ) - D * ( u )
    r_unit.mult -k * (rlen - l) - (d * u.dot(r_unit)), f
    # Add forces to bodies
    bodyA.force.vsub f, bodyA.force
    bodyB.force.vadd f, bodyB.force
    # Angular force
    ri.cross f, ri_x_f
    rj.cross f, rj_x_f
    bodyA.torque.vsub ri_x_f, bodyA.torque
    bodyB.torque.vadd rj_x_f, bodyB.torque
    return