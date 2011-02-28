var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require(['client/game', 'entity', 'camera', 'canvas', 'colour', 'math/vector', 'geometry/polygon', 'geometry/circle', 'physics/collision/SAT', 'physics/world', 'screen'], function(Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, Screen) {
  var $H, $W, $hH, $hW, GameScreen, Wall, canvas, game, rand, wall, wall1, wall2, walls, world, _i, _len;
  game = new Game;
  rand = Math.rand;
  $hW = ($W = 1680) / 2;
  $hH = ($H = 1050) / 2;
  world = new World([$W, $H]);
  world.game = game;
  world.gravity = new Vector(0, 300);
  canvas = new Canvas([$W, $H]);
  canvas.create();
  game.Loop.context = canvas.context;
  extend(window, {
    game: game,
    world: world,
    canvas: canvas,
    SAT: SAT
  });
  Wall = (function() {
    __extends(Wall, Entity.Static);
    function Wall(size) {
      if (size == null) {
        size = [rand(20, 80), rand(20, 80)];
      }
      Wall.__super__.constructor.apply(this, arguments);
      this.body.shape = Polygon.createRectangle(size[0], size[1]);
      this.body.shape.fill = 'red';
    }
    Wall.prototype.render = function(context) {
      return this.body.shape.draw(context);
    };
    return Wall;
  })();
  wall1 = new Wall([10, 10]);
  wall1.body.position = new Vector(10, 10);
  wall2 = new Wall([10, 10]);
  wall2.body.position = new Vector(20, 20);
  walls = [wall1, wall2];
  extend(window, {
    e1: walls[0],
    b1: walls[0].body,
    s1: walls[0].body.shape,
    e2: walls[1],
    b2: walls[1].body,
    s2: walls[1].body.shape
  });
  /*
  	boundaries = [
  		new Wall [$W, 20]
  		new Wall [$W, 20]
  		new Wall [20, $H]
  		new Wall [20, $H]
  	]
  	for wall in boundaries
  		wall.body.coe = 1.0
  		wall.body.shape.fill = new Colour(200, 0, 0).rgb()

  	boundaries[0].body.position = new Vector $hW, 0
  	boundaries[1].body.position = new Vector $hW, $H
  	boundaries[2].body.position = new Vector 0,   $hH
  	boundaries[3].body.position = new Vector $W,  $hH

  	walls = walls.concat boundaries
  	*/
  for (_i = 0, _len = walls.length; _i < _len; _i++) {
    wall = walls[_i];
    world.addEntity(wall);
  }
  GameScreen = (function() {
    __extends(GameScreen, Screen);
    function GameScreen() {
      GameScreen.__super__.constructor.apply(this, arguments);
    }
    GameScreen.prototype.update = function(delta, tick) {
      return world.step(delta);
    };
    GameScreen.prototype.render = function(context) {
      context.clearRect(0, 0, $W, $H);
      return world.render(context);
    };
    return GameScreen;
  })();
  game.Screen.add('game', GameScreen, true);
  window.world = world;
  return $(function() {
    game.Loop.hideFPS();
    game.Loop.delta = 1.0 / 60;
    return game.Loop.start();
  });
});