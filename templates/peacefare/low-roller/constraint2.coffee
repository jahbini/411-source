### 
var CANNON = require('cannon'); 
###

AFRAME.registerComponent('constraint2',
  multiple: true
  schema:
    type:
      default: 'lock'
      oneOf: [
        'coneTwist'
        'distance'
        'hinge'
        'lock'
        'pointToPoint'
        'linearMotor'
        'spring'
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
    distance:
      default: 0
      min: 0
    pivot: type: 'vec3'
    targetPivot: type: 'vec3'
    axis:
      type: 'vec3'
      default:
        x: 0
        y: 0
        z: 1
    targetAxis:
      type: 'vec3'
      default:
        x: 0
        y: 0
        z: 1
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
    
    constraint = undefined
    data = @data
    pivot = new (CANNON.Vec3)(data.pivot.x, data.pivot.y, data.pivot.z)
    targetPivot = new (CANNON.Vec3)(data.targetPivot.x, data.targetPivot.y, data.targetPivot.z)
    axis = new (CANNON.Vec3)(data.axis.x, data.axis.y, data.axis.z)
    targetAxis = new (CANNON.Vec3)(data.targetAxis.x, data.targetAxis.y, data.targetAxis.z)
    constraint = undefined
    switch data.type
      when 'lock'
        constraint = new (CANNON.LockConstraint)(@el.body, data.target.body, maxForce: data.maxForce)
        constraint.type = 'LockConstraint'
      when 'distance'
        constraint = new (CANNON.DistanceConstraint)(@el.body, data.target.body, data.distance, data.maxForce)
        constraint.type = 'DistanceConstraint'
      when 'hinge'
        constraint = new (CANNON.HingeConstraint)(@el.body, data.target.body,
          pivotA: pivot
          pivotB: targetPivot
          axisA: axis
          axisB: targetAxis
          maxForce: data.maxForce)
        constraint.type = 'HingeConstraint'
      when 'coneTwist'
        constraint = new (CANNON.ConeTwistConstraint)(@el.body, data.target.body,
          pivotA: pivot
          pivotB: targetPivot
          axisA: axis
          axisB: targetAxis
          maxForce: data.maxForce)
        constraint.type = 'ConeTwistConstraint'
      when 'pointToPoint'
        constraint = new (CANNON.PointToPointConstraint)(@el.body, pivot, data.target.body, targetPivot, data.maxForce)
        constraint.type = 'PointToPointConstraint'
      when 'spring'
        lA = @data.localAnchor
        lB = @data.localTarget
        constraint = new (Spring)(@el.body, data.target.body,
          localAnchorA: new CANNON.Vec3 lA.x, lA.y, lA.z
          localAnchorB: new CANNON.Vec3 lB.x, lB.y, lB.z
          stiffness: @data.stiffness
          restLength: @data.restLength
          damping: @data.damping)
        constraint.type = 'spring'
      when 'tetraForcer'
        lA = @data.localAnchor
        lB = @data.localTarget
        constraint = new (TetraForcer)(@el.body, data.target.body,
          pid: @data.pid
          minForce: @data.minForce)
        constraint.type = 'linearMotor'
      else
        throw new Error('[constraint] Unexpected type: ' + data.type)
    constraint
)
