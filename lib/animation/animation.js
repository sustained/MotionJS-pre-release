define(['animation/easing'], function(Easing) {
  var Animation, Vector;
  Vector = Math.Vector;
  Animation = (function() {
    Animation.prototype.end = 0;
    Animation.prototype.start = 0;
    Animation.prototype.repeat = false;
    Animation.prototype.active = false;
    Animation.prototype.easing = null;
    Animation.prototype.duration = 1;
    Animation.prototype.listener = null;
    Animation.prototype.reference = null;
    Animation.prototype.endTime = 0;
    Animation.prototype.currTime = 0;
    Animation.prototype.startTime = 0;
    function Animation(options) {
      Motion.extend(this, options);
    }
    Animation.prototype.update = function(delta) {
      this.currTime += delta;
      if (this.currTime > this.endTime) {
        return this.stop();
      } else {
        return this.step();
      }
    };
    Animation.prototype.step = function() {
      var t;
      t = this.currTime / this.duration;
      return this.reference.a(Math.lerp(this.start, this.end, t));
    };
    Animation.prototype.play = function() {
      this.active = true;
      return this.endTime = this.duration;
    };
    Animation.prototype.stop = function() {
      this.active = false;
      return this.reference.a(this.end);
    };
    return Animation;
  })();
  return Animation;
});