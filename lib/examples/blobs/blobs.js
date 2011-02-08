var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require({
  baseUrl: 'http://localhost/Shared/Javascript/MotionJS/lib/'
}, ['motion', 'client/game', 'entity', 'colour', 'geometry/polygon', 'geometry/circle', 'physics/collision/SAT'], function(Motion, ClientGame, Entity, Colour, Polygon, Circle, SAT) {
  var GameScreen, Vector, canvas, game, middle, randV, randX, randY;
  game = new ClientGame;
  Vector = Motion.Vector;
  randX = rand.bind(null, 0, 1024);
  randY = rand.bind(null, 0, 768);
  randV = function() {
    return new Vector(randX(), randY());
  };
  middle = new Vector(1024 / 2, 768 / 2);
  canvas = new Motion.Canvas;
  canvas.create();
  game.Loop.context = canvas.context;
  extend(window, {
    game: game,
    Entity: Entity,
    Colour: Colour,
    Polygon: Polygon,
    Circle: Circle,
    SAT: SAT
  });
  GameScreen = (function() {
    __extends(GameScreen, Motion.Screen);
    function GameScreen() {
      var h, i, shape, spawnMid, spawnTop, w, xCells, xL, xS, yCells, yL, yS, _i, _len, _ref;
      GameScreen.__super__.constructor.apply(this, arguments);
      spawnTop = new Vector(1024 / 2, 0);
      spawnMid = middle.clone();
      this.entity = new Entity(Polygon.createSquare(32, spawnTop.clone()));
      this.entity.position = spawnTop.clone();
      this.shapes = [];
      xCells = 1024 / 32;
      yCells = 768 / 32;
      for (i = 0; i < 20; i++) {
        xS = rand(0, xCells / 2) * xCells;
        yS = rand(0, yCells / 2) * yCells;
        xL = rand(xCells / 2, xCells) * xCells;
        yL = rand(yCells / 2, yCells) * yCells;
        if (rand(0, 1) === 0) {
          w = xS;
          h = yL;
        } else {
          w = xL;
          h = yS;
        }
        this.shapes.push(Polygon.createRectangle(xS / 2, yS / 2, randV()));
      }
      _ref = this.shapes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        shape = _ref[_i];
        shape.stroke = Colour.random(false).a(1.0).rgba();
      }
      this.map = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1], [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1], [1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1], [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1], [1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
      this.mapWidth = this.map[0].length;
      this.mapHeight = this.map.length;
      this.jmp = false;
      this.jmpTime = 0;
    }
    GameScreen.prototype.update = function(Game, delta, tick) {
      var e, i, shape, test, _len, _ref;
      e = this.entity;
      if (Game.Input.isKeyDown('w')) {
        e.velocity.j = -200;
      } else if (Game.Input.isKeyDown('s')) {
        e.velocity.j = 200;
      } else {
        if (e.velocity.j.abs() > 0.00005) {
          e.velocity.j *= 0.8;
        } else {
          e.velocity.j = 0;
        }
      }
      if (Game.Input.isKeyDown('a')) {
        e.velocity.i = -200;
      } else if (Game.Input.isKeyDown('d')) {
        e.velocity.i = 200;
      } else {
        if (e.velocity.i.abs() > 0.00005) {
          e.velocity.i *= 0.8;
        } else {
          e.velocity.i = 0;
        }
      }
      e.velocity.j = e.velocity.j + 50;
      _ref = this.shapes;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        shape = _ref[i];
        test = SAT.test(this.shapes[i], this.entity.shape);
        if (test) {
          e.velocity.add(Vector.multiply(test.separation, 100));
        }
      }
      e.updateVectors(delta);
      if (e.position.j > 768) {
        e.position.j = 0;
      }
      e.shape.position = e.position;
      return;
      if (test) {
        console.log("Overlap: " + test.overlap);
        console.log("Separation: " + test.separation);
        console.log("Unit Vector: " + test.unitVector);
        this.shapes[0].stroke = Colour.get('red').rgba();
      } else {
        this.shapes[0].stroke = Colour.get('green').rgba();
      }
      return;
      this.entity.addForce(new Vector(0, 200));
      if (Game.Input.isKeyDown('a')) {
        this.entity.addForce(new Vector(-50, 0));
      } else if (Game.Input.isKeyDown('d')) {
        this.entity.addForce(new Vector(50, 0));
      } else {
        if (this.entity.velocity.i.abs() > 0.00005) {
          this.entity.velocity.i *= 0.9;
        } else {
          this.entity.velocity.i = 0;
        }
      }
      if (this.entity.position.j > 768) {
        this.entity.position.j = 0;
      }
      return this.entity.update(Game, delta, tick);
    };
    GameScreen.prototype.render = function(Game, context) {
      var cell, i, j, shape, _i, _len, _ref, _ref2, _ref3;
      context.clearRect(0, 0, 1024, 768);
      this.entity.shape.draw(context);
      context.strokeStyle = 'green';
      context.stroke();
      _ref = this.shapes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        shape = _ref[_i];
        shape.draw(context);
        context.stroke();
      }
      return;
      context.fillStyle = 'gray';
      for (j = 0, _ref2 = this.mapHeight; (0 <= _ref2 ? j < _ref2 : j > _ref2); (0 <= _ref2 ? j += 1 : j -= 1)) {
        for (i = 0, _ref3 = this.mapWidth; (0 <= _ref3 ? i < _ref3 : i > _ref3); (0 <= _ref3 ? i += 1 : i -= 1)) {
          cell = this.map[j][i];
          if (cell === 0) {
            continue;
          }
          context.fillRect(i * 32, j * 32, 32, 32);
        }
      }
      context.fillStyle = 'yellow';
      context.beginPath();
      context.arc(this.entity.position.i, this.entity.position.j, 16, 0, Math.TAU, false);
      context.closePath();
      context.fill();
      context.fillStyle = 'black';
      return context.fillRect(this.entity.position.i - 1, this.entity.position.j - 1, 2, 2);
    };
    return GameScreen;
  })();
  return $(function() {
    return;
    game.Loop.delta = 1.0 / 30;
    return game.Loop.start();
  });
});