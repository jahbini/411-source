### 
var CANNON = require('cannon'); 
###

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
    
AFRAME.registerComponent('spring',
  multiple: true
  schema:
    target: type: 'selector'
    maxForce:
      default: 1e6
      min: 0
    collideConnected: default: true
    wakeUpBodies: default: true
    stiffness:
      type: 'number'
      default: 100
    damping:
      type: 'number'
      default: 0.1
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
    data = @data
    lA = @data.localAnchor
    lB = @data.localTarget
    constraint = new (Spring)(@el.body, data.target.body,
      localAnchorA: new CANNON.Vec3 lA.x, lA.y, lA.z
      localAnchorB: new CANNON.Vec3 lB.x, lB.y, lB.z
      stiffness: @data.stiffness
      restLength: @data.restLength
      damping: @data.damping)
    constraint.type = 'spring'
    constraint
)
