var __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
define(['eventful', 'dynamics/body'], function(Eventful, Body) {
  var Dynamic, Entity, Static, _entityId;
  _entityId = 0;
  Entity = (function() {
    function Entity() {}
    return Entity;
  })();
  Static = (function() {
    Static.prototype.body = null;
    Static.prototype.fill = false;
    Static.prototype.stroke = false;
    function Static() {
      this.id = ++_entityId;
      this.body = new Body;
      this.body.static = true;
    }
    Static.prototype.update = function() {
      return null;
    };
    Static.prototype.render = function() {
      return null;
    };
    return Static;
  })();
  Dynamic = (function() {
    Dynamic.prototype.body = null;
    Dynamic.prototype.fill = false;
    Dynamic.prototype.stroke = false;
    function Dynamic() {
      this.id = ++_entityId;
      this.body = new Body;
      this.event = new Eventful(['collision'], {
        binding: this
      });
      this.collisions = [];
      this.behaviours = {};
      this.activeBehaviours = [];
    }
    Dynamic.prototype.addBehaviour = function(name, behaviour, opts) {
      if (opts == null) {
        opts = {};
      }
      opts = Motion.extend({
        active: true,
        parent: this,
        listener: this
      }, opts);
      behaviour = new behaviour(opts.parent, opts.listener);
      this.behaviours[name] = behaviour;
      if (opts.active === true) {
        return this.activeBehaviours.push(name);
      }
    };
    Dynamic.prototype.getBehaviour = function(name) {
      return this.behaviours[name] || void 0;
    };
    Dynamic.prototype.removeBehaviour = function(name) {
      if (__indexOf.call(this.behaviours, name) >= 0) {
        this.behaviours = this.behaviours.remove(name);
        true;
      }
      return false;
    };
    Dynamic.prototype.input = function() {
      return null;
    };
    Dynamic.prototype.damping = function() {
      return null;
    };
    Dynamic.prototype.update = function() {
      var i, _i, _len, _ref, _results;
      _ref = this.activeBehaviours;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        _results.push(this.behaviours[i].update());
      }
      return _results;
    };
    Dynamic.prototype.render = function() {
      var i, _i, _len, _ref, _results;
      _ref = this.activeBehaviours;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        _results.push(this.behaviours[i].render());
      }
      return _results;
    };
    return Dynamic;
  })();
  return {
    Static: Static,
    Dynamic: Dynamic
  };
});