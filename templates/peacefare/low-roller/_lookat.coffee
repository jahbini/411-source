debug = AFRAME.utils.debug
coordinates = AFRAME.utils.coordinates
warn = debug('components:look-at:warn')
isCoordinates = coordinates.isCoordinates or coordinates.isCoordinate
delete AFRAME.components['look-at']

###*
# Look-at component.
#
# Modifies rotation to either track another entity OR do a one-time turn towards a position
# vector.
#
# If tracking an object via setting the component value via a selector, look-at will register
# a behavior to the scene to update rotation on every tick.
###

AFRAME.registerComponent 'look-at',
  schema:
    default: ''
    parse: (value) ->
      # A static position to look at.
      if isCoordinates(value) or typeof value == 'object'
        return coordinates.parse(value)
      # A selector to a target entity.
      value
    stringify: (data) ->
      if typeof data == 'object'
        return coordinates.stringify(data)
      data
  init: ->
    @target3D = null
    @vector = new (THREE.Vector3)
    return
  update: ->
    self = this
    target = self.data
    object3D = self.el.object3D
    targetEl = undefined
    # No longer looking at anything (i.e., look-at="").
    if !target or typeof target == 'object' and !Object.keys(target).length
      return self.remove()
    # Look at a position.
    if typeof target == 'object'
      return object3D.lookAt(new (THREE.Vector3)(target.x, target.y, target.z))
    # Assume target is a string.
    # Query for the element, grab its object3D, then register a behavior on the scene to
    # track the target on every tick.
    targetEl = self.el.sceneEl.querySelector(target)
    if !targetEl
      warn '"' + target + '" does not point to a valid entity to look-at'
      return
    if !targetEl.hasLoaded
      return targetEl.addEventListener('loaded', ->
        self.beginTracking targetEl
        return
      )
    self.beginTracking targetEl
  tick: do ->
    vec3 = new (THREE.Vector3)
    (t) ->
      # Track target object position. Depends on parent object keeping global transforms up
      # to state with updateMatrixWorld(). In practice, this is handled by the renderer.
      target = undefined
      target3D = @target3D
      object3D = @el.object3D
      vector = @vector
      if target3D
        object3D.parent.worldToLocal target3D.getWorldPosition(vec3)
        if @el.getObject3D('camera')
          # Flip the vector to -z, looking away from target for camera entities. When using
          # lookat from THREE camera objects, this is applied for you, but since the camera is
          # nested into a Object3D, we need to apply this manually.
          vector.subVectors(object3D.position, vec3).add object3D.position
        else
          vector = vec3
        object3D.lookAt vector
      return
  beginTracking: (targetEl) ->
    @target3D = targetEl.object3D
    return
