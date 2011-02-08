var stateful;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
stateful = function(Motion, Eventful) {
  var Stateful;
  Stateful = (function() {
    __extends(Stateful, Motion.Class);
    function Stateful(Game) {
      this.Game = Game;
      Stateful.__super__.constructor.call(this);
      this.Event = new Eventful('beforeUpdate', 'afterUpdate', 'beforeRender', 'afterRender');
      this.states = {};
      this.enabled = {};
    }
    Stateful.prototype.isState = function(name) {
      return name in this.states;
    };
    Stateful.prototype.update = function(Game, tick, delta) {
      var state;
      this.Event.fire('beforeUpdate', [Game, tick, delta]);
      for (state in this.states) {
        if (this.enabled[state] === false && this.states[state].continuous === false) {
          continue;
        }
        this.states[state].update(Game, tick, delta);
      }
      this.Event.fire('afterUpdate', [Game, tick, delta]);
      return;
    };
    Stateful.prototype.render = function(Game, alpha, context) {
      var state;
      this.Event.fire('beforeRender', [Game, alpha, context]);
      for (state in this.states) {
        if (this.enabled[state] === false && this.states[state].continuous === false) {
          continue;
        }
        this.states[state].render(Game, alpha, context);
      }
      this.Event.fire('afterRender', [Game, alpha, context]);
      return;
    };
    Stateful.prototype.create = function(name, state, enabled) {
      if (enabled == null) {
        enabled = false;
      }
      if (this.isState(name)) {
        return null;
      }
      state.name = name;
      this.states[name] = state;
      this.enabled[name] = enabled;
      return this.states[name];
    };
    Stateful.prototype.remove = function(name) {
      if (this.isState(name)) {
        this.disable(name);
        this.states[name].Event.fire('delete');
      }
      return this;
    };
    Stateful.prototype.enable = function(name) {
      if (this.isState(name)) {
        this.enabled[name] = true;
        this.states[name].enableTime = this.Game.Loop.time;
        this.states[name].Event.fire('enable');
      }
      return this;
    };
    Stateful.prototype.disable = function(name) {
      if (this.isState(name && this.states[name].continuous === false)) {
        this.enabled[name] = false;
        this.states[name].disableTime = this.Game.Loop.time;
        this.states[name].Event.fire('disable');
      }
      return this;
    };
    return Stateful;
  })();
  return Stateful;
};
define(['motion', 'eventful'], stateful);