var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['behaviours/behaviour'], function(Behaviour) {
  /*
  		parent   is an AABB
  		listener is an Entity
  	*/  var Clickable;
  Clickable = (function() {
    __extends(Clickable, Behaviour);
    Clickable.prototype.highlight = false;
    function Clickable(parent, listener, options) {
      if (options == null) {
        options = {};
      }
      Clickable.__super__.constructor.call(this, parent, listener);
      this.parent.hovered = this.parent.clicked = false;
      this.aabb = this.parent.body.aabb;
    }
    Clickable.prototype.update = function() {
      this.parent.hovered = this.parent.clicked = false;
      if (this.aabb.containsPoint(globalgame.Input.mouse.position.game)) {
        this.parent.hovered = true;
        this.listener.hover();
        if (globalgame.Input.mouse.left) {
          this.parent.clicked = true;
          return this.listener.click();
        }
      }
    };
    return Clickable;
  })();
  return Clickable;
});