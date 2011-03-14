var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', 'class', 'eventful', 'loop', 'input', 'screenmanager'], function(Motion, Class, Eventful, Loop, Input, MScreen) {
  var Application;
  Application = (function() {
    __extends(Application, Class);
    function Application() {
      Application.__super__.constructor.call(this);
      if (Motion.env === 'client') {
        this.Input = new Input;
        this.Screen = new MScreen(this);
      }
      this.Loop = new Loop(this);
      this.Event = new Eventful;
    }
    return Application;
  })();
  return Application;
});