var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['behaviours/behaviour'], function(Behaviour) {
  var Draggable, Vector;
  Vector = Math.Vector;
  Draggable = (function() {
    __extends(Draggable, Behaviour);
    Draggable.prototype.difference = null;
    function Draggable(parent, listener, options) {
      if (options == null) {
        options = {};
      }
      Draggable.__super__.constructor.call(this, parent, listener);
    }
    Draggable.prototype.update = function() {
      if (this.parent.clicked) {
        this.parent.body.gravity = this.parent.body.collide = false;
        return this.parent.body.position = globalgame.Input.mouse.position.game.clone();
      } else {
        return this.parent.body.gravity = this.parent.body.collide = true;
      }
    };
    return Draggable;
  })();
  return Draggable;
});