var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require(['motion', 'loop', 'input', 'screenmanager', 'screen', 'canvas', 'colour'], function(Motion, Loop, Input, MScreen, Screen, Canvas, Colour) {
  var App;
  App = (function() {
    __extends(App, Motion.Class);
    function App() {
      App.__super__.constructor.apply(this, arguments);
      if (Motion.env === 'client') {
        this.Input = new Input;
        this.Screen = new MScreen(this);
      }
      this.Loop = new Loop(this);
    }
    App.prototype.update = function() {};
    App.prototype.render = function() {};
    return App;
  })();
  return App;
});