var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['class', 'eventful', 'stateful', 'loop', 'input', 'canvas', 'screenmanager', 'physics/world'], function(Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World) {
  var Game;
  Game = (function() {
    __extends(Game, Class);
    function Game(options) {
      var _ref;
      options = Motion.ext({
        size: [1024, 768],
        delta: 1.0 / 60
      }, options);
      Game.__super__.constructor.call(this);
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
    }
    return Game;
  })();
  return Game;
});