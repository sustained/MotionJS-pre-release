var AnimationBehaviour, Behaviour, FallingBlockBehaviour, MotionBehaviour;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Behaviour = (function() {
  Behaviour.prototype._update = noop;
  Behaviour.prototype._render = noop;
  Behaviour.prototype._lastUpdate = 0;
  Behaviour.prototype._lastRender = 0;
  Behaviour.prototype.active = true;
  Behaviour.prototype.entity = null;
  function Behaviour(Game) {
    this.Game = Game;
    if (!Game instanceof Motion.Game) {
      throw 'Need @Game';
    }
    Class.get(this, 'update', function() {
      return this._update;
    });
    Class.set(this, 'update', function(update) {
      return this._update = isFunction(update) ? update.bind(this, this.Game) : noop;
    });
    Class.get(this, 'render', function() {
      return this._render;
    });
    Class.set(this, 'render', function(render) {
      return this._render = isFunction(render) ? render.bind(this, this.Game) : noop;
    });
  }
  Behaviour.prototype.doUpdate = function(Game) {
    if (!this.active) {
      return;
    }
    this._update(Game.Loop.tick, Game.Loop.delta);
    return this._lastUpdate = Game.Loop.tick.round();
  };
  Behaviour.prototype.doRender = function(Game) {
    if (!this.active) {
      return;
    }
    this._render(Game.Loop.alpha, Game.Loop.context);
    return this._lastRender = Game.Loop.tick.round();
  };
  return Behaviour;
})();
FallingBlockBehaviour = (function() {
  __extends(FallingBlockBehaviour, Behaviour);
  function FallingBlockBehaviour() {
    this.lastUpdate = 0;
  }
  FallingBlockBehaviour.prototype.update = function(tick, delta) {
    if (tick.round() - this.lastUpdate > 1) {
      return this.lastUpdate = tick.round();
    }
  };
  return FallingBlockBehaviour;
})();
AnimationBehaviour = (function() {
  __extends(AnimationBehaviour, Behaviour);
  function AnimationBehaviour(entity, frameDuration, animation, listener) {
    this.entity = entity;
    this.frameDuration = frameDuration;
    this.animation = animation;
    this.listener = listener;
    this.currentTime = 0;
    this.currentFrame = 0;
  }
  AnimationBehaviour.prototype.update = function(tick, delta) {
    this.currentTime = tick;
    if (this.currentTime >= this.frameDuration) {
      this.currentTime -= this.frameDuration;
      this.currentFrame++;
      if (this.currentFrame < this.animation.length) {
        return this.parent.setImage(this.animation[this.currentFrame]);
      } else {
        return null;
      }
    }
  };
  AnimationBehaviour.prototype.reset = function() {
    this.active = true;
    return this.currentFrame = 0;
  };
  return AnimationBehaviour;
})();
MotionBehaviour = (function() {
  __extends(MotionBehaviour, Behaviour);
  function MotionBehaviour(parent) {
    this.parent = parent;
    this.active = false;
    this.velocity = new Vector;
    this.maxVelocity = new Vector;
    this.acceleration = new Vector;
  }
  MotionBehaviour.prototype.update = function() {};
  return MotionBehaviour;
})();