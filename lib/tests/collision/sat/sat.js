var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['client/game', 'dynamics/world', 'geometry/circle', 'geometry/polygon', 'collision/aabb', 'screen', 'entity', 'camera', 'animation/animation', 'animation/easing'], function(Game, World, Circle, Polygon, AABB, Screen, Entity, Camera, Animation, Easing) {
  var Bar, Colour, Foo, GameScreen, Vector, game, i, player1, player2, _ref;
  game = new Game;
  Vector = Math.Vector;
  Colour = Motion.Colour;
  Motion.root.world = game.world;
  Motion.root.canvas = game.canvas;
  Motion.root.globalgame = game;
  world.bounds = (_ref = [1024, 768], world.w = _ref[0], world.h = _ref[1], _ref);
  Foo = (function() {
    __extends(Foo, Entity.Static);
    function Foo() {
      var size;
      Foo.__super__.constructor.apply(this, arguments);
      this.collideType = 0x1;
      size = rand(10, 20);
      this.body.coe = 0.5;
      this.body.shape = Polygon.createShape(rand(3, 8), size, size);
      this.body.aabb.setExtents(this.body.shape.calculateAABBExtents());
      this.body.shape.fill = new Colour(255, 0, 0, 0.25);
      this.body.position = world.randomV();
    }
    Foo.prototype.render = function(context) {
      this.body.shape.draw(context);
      return canvas.polygon([new Vector(this.body.aabb.l, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.b), new Vector(this.body.aabb.l, this.body.aabb.b)], {
        stroke: 'rgba(0, 255, 0, 0.5)'
      });
    };
    return Foo;
  })();
  for (i = 0; i < 10; i++) {
    world.addEntity(new Foo);
  }
  Bar = (function() {
    __extends(Bar, Entity.Dynamic);
    Bar.prototype.controls = null;
    function Bar() {
      var size;
      Bar.__super__.constructor.apply(this, arguments);
      this.collideType = 0x2;
      this.collideWith = 0x1 | 0x2;
      size = 30;
      this.body.coe = 0.0;
      this.body.cof = 0.5;
      this.body.shape = Polygon.createRectangle(size, size);
      this.body.aabb.setExtents(15);
      this.body.shape.fill = new Colour(0, 0, 255, 0.25);
      this.body.position = world.randomV();
      this.body.caabb = new AABB(this.body.position, 50);
    }
    Bar.prototype.collide = function(collision, entity) {
      return true;
    };
    Bar.prototype.update = function(delta, tick) {
      var vel;
      this.input();
      vel = this.body.velocity.clone();
      if (vel.i < 0) {
        this.body.caabb.setLeft(Math.max(50, vel.i.abs()));
      }
      this.body.caabb.setRight(50);
      if (vel.i > 0) {
        this.body.caabb.setLeft(50);
        this.body.caabb.setRight(Math.max(50, vel.i));
      }
      if (vel.j < 0) {
        this.body.caabb.setTop(Math.max(50, vel.j.abs()));
        this.body.caabb.setBottom(50);
      }
      if (vel.j > 0) {
        this.body.caabb.setTop(50);
        this.body.caabb.setBottom(Math.max(50, vel.j));
      }
      this.body.aabb.setPosition(this.body.position);
      return this.body.caabb.setPosition(this.body.position);
      /*
      			extents.l = if vel.i < 0 then vel.i.abs() else 50
      			extents.r = if vel.i > 0 then vel.i       else 50
      			extents.t = if vel.j < 0 then vel.j.abs() else 50
      			extents.b = if vel.j > 0 then vel.j       else 50
      			*/
    };
    Bar.prototype.input = function() {
      if (game.Input.isKeyDown(this.controls.l)) {
        this.body.velocity.i -= 5;
      } else if (game.Input.isKeyDown(this.controls.r)) {
        this.body.velocity.i += 5;
      } else {
        if (this.body.velocity.i.abs() < 0.001) {
          this.body.velocity.i = 0;
        } else {
          this.body.velocity.i *= 0.97;
        }
      }
      if (game.Input.isKeyDown(this.controls.u)) {
        return this.body.velocity.j -= 5;
      } else if (game.Input.isKeyDown(this.controls.d)) {
        return this.body.velocity.j += 5;
      } else {
        if (this.body.velocity.j.abs() < 0.001) {
          return this.body.velocity.j = 0;
        } else {
          return this.body.velocity.j *= 0.97;
        }
      }
    };
    Bar.prototype.render = function(context) {
      this.body.shape.draw(context);
      canvas.rectangle(this.body.position.clone(), [this.body.aabb.w, this.body.aabb.h], {
        mode: 'center',
        stroke: 'rgba(0, 255, 0, 0.5)',
        width: 1
      });
      return canvas.polygon([new Vector(this.body.caabb.l, this.body.caabb.t), new Vector(this.body.caabb.r, this.body.caabb.t), new Vector(this.body.caabb.r, this.body.caabb.b), new Vector(this.body.caabb.l, this.body.caabb.b)], {
        stroke: 'rgba(0, 255, 0, 0.5)'
      });
    };
    return Bar;
  })();
  player1 = window.player1 = new Bar;
  player2 = window.player2 = new Bar;
  player1.body.mass = 100;
  player1.controls = {
    u: 'w',
    d: 's',
    l: 'a',
    r: 'd'
  };
  player2.controls = {
    u: 'up',
    d: 'down',
    l: 'left',
    r: 'right'
  };
  world.addEntity(player1);
  GameScreen = (function() {
    __extends(GameScreen, Screen);
    function GameScreen() {
      GameScreen.__super__.constructor.apply(this, arguments);
      this.camera = new Camera([1024, 768]);
      this.camera.attach(world.entities[player1.id]);
      this.test = new Animation({
        start: 0.25,
        end: 1.0,
        duration: 10,
        reference: player1.body.shape.fill
      });
    }
    GameScreen.prototype.update = function(delta, tick) {
      world.step(delta);
      this.camera.update(delta);
      this.test.update(delta);
      return game.Input.update(this.camera);
    };
    GameScreen.prototype.render = function(context) {
      context.clearRect(0, 0, 1024, 768);
      context.translate(-this.camera.position.i.round(), -this.camera.position.j.round());
      world.render(context, this.camera);
      return context.translate(this.camera.position.i.round(), this.camera.position.j.round());
    };
    return GameScreen;
  })();
  game.Screen.add('game', GameScreen, true);
  Motion.root.screen = game.Screen.screens.game;
  return $(function() {
    return game.Loop.start();
  });
});