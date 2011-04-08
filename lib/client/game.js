var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['class', 'eventful', 'stateful', 'loop', 'input', 'canvas', 'screenmanager', 'dynamics/world', 'client/input/keyboard', 'client/input/mouse'], function(Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World, Keyboard, Mouse) {
  var Game, _instance;
  _instance = null;
  return Game = (function() {
    __extends(Game, Class);
    Game.instance = function() {
      if (_instance) {
        return _instance;
      } else {
        return new this;
      }
    };
    function Game(options) {
      if (_instance != null) {
        return _instance;
      }
      Game.__super__.constructor.call(this);
      options = Motion.extend({
        url: '',
        size: [1024, 768],
        delta: 1.0 / 60
      }, options);
      this.worlds = {};
      this.createWorld('default', options.size);
      this.input = this.Input = new Input;
      this.screen = this.Screen = new MScreen(this);
      this.mouse = new Mouse;
      this.keyboard = new Keyboard;
      this.loop = this.Loop = new Loop(this);
      this.loop.delta = options.delta;
      this.event = this.Event = new Eventful;
      this.canvas = new Canvas(options.size);
      this.canvas.create();
      this.loop.context = this.canvas.context;
      this.input.setup(this.canvas.$canvas);
      _instance = this;
    }
    Game.prototype.createWorld = function(name, options) {
      this.worlds[name] = new World(options);
      return this.worlds[name].game = this;
    };
    Game.prototype.getWorld = function(name) {
      return this.worlds[name];
    };
    Game.prototype.removeWorld = function(name) {
      return delete this.worlds[name];
    };
    return Game;
  })();
});