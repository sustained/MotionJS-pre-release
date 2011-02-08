var Guy;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Guy = (function() {
  __extends(Guy, Entity);
  function Guy() {
    this.addBehaviour('walk', new WalkingAnimationBehaviour(this.getAnimation('walk')));
    this.addBehaviour('jump', new JumpingAnimationBehaviour(this.getAnimation('jump')));
    this.addBehaviour('fall', new FallingAnimationBehaviour(this.getAnimation('fall')));
    this.addBehaviour('click', new ClickBehaviour(function() {}));
  }
  Guy.prototype.update = function() {
    return this.updateBehaviours();
  };
  Guy.prototype.render = function() {};
  return Guy;
})();