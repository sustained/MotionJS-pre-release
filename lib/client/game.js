var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', 'class', 'eventful', 'stateful', 'loop', 'input', 'screenmanager'], function(Motion, Class, Eventful, Stateful, Loop, Input, MScreen) {
  var Game;
  Game = (function() {
    var _instance;
    __extends(Game, Class);
    _instance = null;
    function Game() {
      Game.__super__.constructor.call(this);
      if (Motion.env === 'client') {
        this.Input = new Input;
        this.Screen = new MScreen(this);
      }
      this.Loop = new Loop(this);
      this.Event = new Eventful;
    }
    return Game;
  })();
  return Game;
});