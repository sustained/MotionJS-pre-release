define(['eventful', 'physics/body'], function(Eventful, Body) {
  var Dynamic, Static, _entityId;
  _entityId = 0;
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
      this.behaviours = {};
      this.activeBehaviours = [];
    }
    Dynamic.prototype.input = function() {
      return null;
    };
    Dynamic.prototype.damping = function() {
      return null;
    };
    Dynamic.prototype.update = function() {
      return null;
    };
    Dynamic.prototype.render = function() {
      return null;
    };
    return Dynamic;
  })();
  return {
    Static: Static,
    Dynamic: Dynamic
  };
});