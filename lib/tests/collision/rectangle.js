var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['loop', 'physics/world', 'geometry/circle', 'geometry/polygon'], function(Game, World, Circle, Polygon) {
  var GameScreen, canvas, circ1, circ2, gloop, poly1, poly2, rect1, rect2, world;
  gloop = new Loop;
  gloop.delta = 1.0 / 60;
  world = new World([1024, 768]);
  canvas = new Canvas([1024, 768]);
  canvas.create();
  game.Loop.context = canvas.context;
  game.Input.setup(canvas.$canvas);
  rect1 = Polygon.createRectangle(100, 100, new Vector(0, 0));
  rect2 = Polygon.createRectangle(20, 100, new Vector(20, 0));
  circ1 = new Circle(50, new Vector(100, 100));
  circ2 = new Circle(50, new Vector(200, 200));
  poly1 = Polygon.createShape(3, 100, new Vector(100, 20));
  poly2 = Polygon.createShape(3, 100, new Vector(0, 50));
  return GameScreen = (function() {
    __extends(GameScreen, Screen);
    function GameScreen() {
      GameScreen.__super__.constructor.apply(this, arguments);
      this.camera = new Camera([$W, $H]);
      this.camera.attach(world.groups.player[1]);
    }
    GameScreen.prototype.update = function(delta, tick) {
      world.step(delta);
      this.camera.update(delta);
      return game.Input.update(this.camera);
    };
    GameScreen.prototype.render = function(context) {
      context.clearRect(0, 0, $W, $H);
      context.translate(-this.camera.position.i, -this.camera.position.j);
      world.render(context, this.camera);
      return context.translate(this.camera.position.i, this.camera.position.j);
    };
    return GameScreen;
  })();
});