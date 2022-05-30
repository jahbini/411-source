// Generated by CoffeeScript 1.12.7
(function() {
  var PID;

  PID = PID = (function() {

    /*
    the PID style of controller is intended to track a quantity from the real world as detected by some sensor.
    The sensor is assumed to be reliable as possible, consistent and acccurate.
    the output of the controller is a single quantity that controls a single output device.
    The output device is related in some fashion to changes in the real world that affect the sensor.
    A PID controller ses the input values to compte an output variable by looking at three internally 
    computed quantities.
    1) the Proportial component, which simply is related to "How far away from our goal are we?"
    2) the Integral component, which is related to "How far have we come to our goal?"
    3) the Differential component, which asks "are we taking big steps, or tiny ones?"
     */
    function PID(proportionalParm, integrationParm, derivativeParm, dt) {
      var integrationLimit, options;
      if (typeof proportionalParm === 'object') {
        options = proportionalParm;
        proportionalParm = options.proportionalParm;
        integrationParm = options.integrationParm;
        derivativeParm = options.derivativeParm;
        dt = options.dt || 0;
        integrationLimit = options.integrationLimit;
      }
      this.proportionalParm = typeof proportionalParm === 'number' ? proportionalParm : 1;
      this.integrationParm = integrationParm || 0;
      this.derivativeParm = derivativeParm || 0;
      this.dt = dt || 0;
      this.integrationLimit = integrationLimit || 0;
      this.sumDelta = 0;
      this.lastDelta = 0;
      this.setTarget(0);
      return;
    }

    PID.prototype.setTarget = function(target) {
      this.target = target;
      this.lastTime = Date.now();
    };

    PID.prototype.update = function(currentValue) {
      var currentTime, dDelta, delta, dt, ref, sumSign;
      this.currentValue = currentValue;
      dt = this.dt;
      if (!dt) {
        currentTime = Date.now();
        dt = (currentTime - this.lastTime) / 1000;
        this.lastTime = currentTime;
      }
      if (typeof dt !== 'number' || dt === 0) {
        dt = 1;
      }
      delta = this.target - this.currentValue;
      this.sumDelta = this.sumDelta + delta * dt;
      if ((0 < (ref = this.integrationLimit) && ref < Math.abs(this.sumDelta))) {
        sumSign = this.sumDelta > 0 ? 1 : -1;
        this.sumDelta = sumSign * this.integrationLimit;
      }
      dDelta = (delta - this.lastDelta) / dt;
      this.lastDelta = delta;
      return (this.proportionalParm * delta) + (this.integrationParm * this.sumDelta) + (this.derivativeParm * dDelta);
    };

    PID.prototype.reset = function() {
      this.sumDelta = 0;
      this.lastDelta = 0;
      this.setTarget(0);
    };

    return PID;

  })();

  if (typeof module !== "undefined" && module !== null ? module.exports : void 0) {
    module.exports = PID;
  }

  if (window) {
    window.PID = PID;
  }

}).call(this);