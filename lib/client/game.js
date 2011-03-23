var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['class', 'eventful', 'stateful', 'loop', 'input', 'canvas', 'screenmanager', 'dynamics/world'], function(Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World) {
  var Game, __instance;
  __instance = null;
  Game = (function() {
    __extends(Game, Class);
    function Game(options) {
      var _ref;
      if (__instance != null) {
        return __instance;
      }
      Game.__super__.constructor.call(this);
      options = Motion.extend({
        size: [1024, 768],
        delta: 1.0 / 60
      }, options);
      this.world = new World([2000, 2000]);
      this.world.game = this;
      if (Motion.env === 'client') {
        this.Input = new Input;
        this.Screen = new MScreen(this);
      }
      this.Loop = new Loop(this);
      this.Loop.delta = options.delta;
      this.Event = new Eventful;
      this.canvas = new Canvas(options.size);
      this.canvas.create();
      this.Loop.context = this.canvas.context;
      if ((_ref = this.Input) != null) {
        _ref.setup(this.canvas.$canvas);
      }
      __instance = this;
    }
    Game.prototype.createWorld = function(name, options) {
      options = Motion.extend({
        size: [1024, 768]
      }, options);
      return this.worlds[name] = new World(options);
    };
    Game.prototype.removeWorld = function(name) {
      return delete this.worlds[name];
    };
    return Game;
  })();
  return Game;
});