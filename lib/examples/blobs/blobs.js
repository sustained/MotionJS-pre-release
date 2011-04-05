var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require(['client/game', 'screen', 'camera', 'canvas', 'colour', 'geometry/polygon', 'geometry/circle', 'collision/sat', 'collision/aabb', 'dynamics/world', 'game/entities/blob', 'game/entities/wall', 'game/entities/portal', 'game/entities/powerup', 'game/entities/weapon'], function(Game, Screen, Camera, Canvas, Colour, Polygon, Circle, SAT, AABB, World, Blob, Wall, Portal, Powerup, Weapon) {
  var $H, $W, $hH, $hW, GameScreen, Matrix, Vector, boundaries, canvas, coe, cof, game, i, player1, powerup, powerups, rand, wall, walls, weapon, weapons, world, _i, _j, _len, _len2;
  Vector = Math.Vector, Matrix = Math.Matrix, rand = Math.rand;
  game = new Game({
    size: [1024, 768],
    delta: 1.0 / 60
  });
  world = game.world, canvas = game.canvas;
  Motion.root.world = world;
  Motion.root.canvas = canvas;
  Motion.root.globalgame = game;
  world.w = world.h = 10000;
  world.gravity = new Vector(0, 250);
  $hW = ($W = 1024) / 2;
  $hH = ($H = 768) / 2;
  player1 = new Blob;
  player1.body.position = new Vector($hW + 25, 100);
  player1.keys = {
    l: 'a',
    r: 'd',
    j: 'w'
  };
  world.addEntity(player1);
  /*player2 = new Blob
  	player2.body.position = new Vector $hW - 25, 100
  	player2.keys = l: 'left', r: 'right', j: 'up'

  	world.addEntity player2*/
  walls = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 1000; i++) {
      wall = new Wall;
      coe = Math.random();
      cof = 0.01;
      if (coe < 0.1) {
        coe = 0.1;
      }
      if (coe > 0.5) {
        coe = 0.5;
      }
      wall.body.coe = coe;
      wall.body.cof = cof;
      wall.body.shape.fill = new Colour(Math.remap(coe, [0, 1], [0, 255]).round(), 0, 0).rgb();
      wall.body.shape.stroke = new Colour(0, Math.remap(cof, [0, 1], [0, 255]).round(), 0).rgb();
      _results.push(world.addEntity(wall));
    }
    return _results;
  })();
  boundaries = [new Wall([world.w, 10]), new Wall([world.w, 10]), new Wall([10, world.h]), new Wall([10, world.h])];
  for (_i = 0, _len = boundaries.length; _i < _len; _i++) {
    wall = boundaries[_i];
    wall.body.coe = 1;
    wall.body.cof = 0;
    wall.body.shape.fill = new Colour(0, 0, 200, 0.8).rgba();
  }
  boundaries[0].body.position = new Vector(world.w / 2, 0);
  boundaries[1].body.position = new Vector(world.w / 2, world.w);
  boundaries[2].body.position = new Vector(0, world.h / 2);
  boundaries[3].body.position = new Vector(world.w, world.h / 2);
  for (_j = 0, _len2 = boundaries.length; _j < _len2; _j++) {
    wall = boundaries[_j];
    world.addEntity(wall);
  }
  powerups = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 100; i++) {
      powerup = new Powerup;
      _results.push(world.addEntity(powerup));
    }
    return _results;
  })();
  weapons = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 10; i++) {
      weapon = new Weapon;
      weapon.body.shape.fill = 'blue';
      world.addEntity(weapon);
      _results.push(weapon);
    }
    return _results;
  })();
  /*
  	portals[0].body.position = new Vector 50, $hH
  	portals[1].body.position = new Vector $hW, 50
  	portals[2].body.position = new Vector $W - 50, $hH
  	portals[3].body.position = new Vector $hW, $H - 50

  	portals[0].portal = portals[1]
  	portals[1].portal = portals[0]

  	portals[2].portal = portals[3]
  	portals[3].portal = portals[2]
  	*/
  GameScreen = (function() {
    __extends(GameScreen, Screen);
    function GameScreen() {
      GameScreen.__super__.constructor.apply(this, arguments);
      this.camera = new Camera([$W, $H]);
      this.camera.attach(player1);
    }
    GameScreen.prototype.update = function(delta, tick) {
      world.step(delta);
      this.camera.update(delta);
      return game.Input.update(this.camera);
    };
    GameScreen.prototype.findWeapons = function() {
      var i;
      for (i = 0; i <= 10; i++) {
        canvas.line(weapons[i].body.position, player1.body.position, {
          stroke: 'rgba(100, 100, 100, 0.25)'
        });
      }
    };
    GameScreen.prototype.render = function(context) {
      context.clearRect(0, 0, $W, $H);
      context.translate(-this.camera.position.i.round(), -this.camera.position.j.round());
      world.render(context, this.camera);
      this.camera.render(canvas);
      this.findWeapons();
      return context.translate(this.camera.position.i.round(), this.camera.position.j.round());
    };
    return GameScreen;
  })();
  game.Screen.add('game', GameScreen, true);
  window.world = world;
  return $(function() {
    return game.Loop.start();
  });
});