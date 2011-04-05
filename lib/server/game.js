var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['class', 'eventful', 'loop', 'dynamics/world', 'path'], function(Class, Eventful, Loop, World, path) {
  var Game, __instance;
  __instance = null;
  Game = (function() {
    __extends(Game, Class);
    function Game(options) {
      if (__instance != null) {
        return __instance;
      }
      Game.__super__.constructor.call(this);
      this.options = Motion.extend({
        path: '',
        delta: 1.0 / 10
      }, options);
      if (this.path = options.path) {
        this.load();
      }
      this.loop = this.Loop = new Loop(this);
      this.loop.delta = options.delta;
      this.event = this.Event = new Eventful;
      this.worlds = {};
      this.createWorld('default');
      __instance = this;
    }
    Game.prototype.createWorld = function(name, options) {
      options = Motion.extend({
        size: [1024, 768]
      }, options);
      return this.worlds[name] = new World(options);
    };
    Game.prototype.getWorld = function(name) {
      return this.worlds[name];
    };
    Game.prototype.removeWorld = function(name) {
      return delete this.worlds[name];
    };
    Game.prototype.load = function() {
      var entities;
      if (path.existsSync(this.path)) {
        entities = listFiles("" + this.path + "src/");
        return console.log(entities);
      }
    };
    return Game;
  })();
  return Game;
});