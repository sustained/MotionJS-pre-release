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
}, ['motion', 'client/game'], function(Motion, ClientGame) {
  var One, Two, canvas, game, randX, randY;
  game = window.game = new ClientGame;
  randX = rand.bind(null, 0, 1024);
  randY = rand.bind(null, 0, 768);
  One = (function() {
    __extends(One, Motion.Screen);
    One.prototype.zIndex = 1;
    function One() {
      One.__super__.constructor.apply(this, arguments);
      this.nospam = 0;
    }
    One.prototype.update = function(Game, delta, tick) {};
    One.prototype.render = function(Game, context) {
      context.clearRect(0, 0, 1024, 768);
      context.fillStyle = 'red';
      return context.fillRect(-20 + (1024 / 2), -20 + (768 / 2), 50, 50);
    };
    return One;
  })();
  Two = (function() {
    __extends(Two, Motion.Screen);
    Two.prototype.zIndex = 2;
    function Two() {
      Two.__super__.constructor.apply(this, arguments);
      this.nospam = 0;
    }
    Two.prototype.update = function(Game, delta, tick) {};
    Two.prototype.render = function(Game, context) {
      context.clearRect(0, 0, 1024, 768);
      context.beginPath();
      context.arc(1024 / 2, 768 / 2, 15, Math.TAU, false);
      context.closePath();
      context.fillStyle = 'blue';
      return context.fill();
    };
    return Two;
  })();
  canvas = new Motion.Canvas;
  canvas.create();
  game.Loop.context = canvas.context;
  game.Screen.add('one', One);
  game.Screen.add('two', Two);
  console.log(game.Screen.enabled);
  console.log(game.Screen.sort());
  return game.Loop.start();
});