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
}, ['motion', 'client/game', 'entity', 'camera', 'colour', 'geometry/polygon', 'geometry/circle', 'collision/SAT'], function(Motion, game, Entity, Camera, Colour, Polygon, Circle, SAT) {
  var EditorScreen, Vector, canvas;
  Vector = Motion.Vector;
  /*
  	buffer = new Motion.Canvas [32, 768]
  	buffer.create()

  	c = buffer.context
  	c.strokeStyle = 'rgb(50, 50, 50)'

  	for x in [0..1]
  		c.beginPath()
  		c.moveTo x * 32, 0
  		c.lineTo x * 32, 768
  		c.closePath()

  		c.stroke()

  	for y in [0..24]
  		c.beginPath()
  		c.moveTo    0, y * 32
  		c.lineTo 1024, y * 32
  		c.closePath()

  		c.stroke()

  	#pixelData = c.getImageData 0, 0, 32, 768
  	imageData = buffer.canvas
  	*/
  canvas = new Motion.Canvas([1680, 1050]);
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
  EditorScreen = (function() {
    __extends(EditorScreen, Motion.Screen);
    function EditorScreen() {
      EditorScreen.__super__.constructor.apply(this, arguments);
    }
    EditorScreen.prototype.update = function(Game, delta, tick) {};
    EditorScreen.prototype.render = function(Game, c) {
      return c.clearRect(0, 0, 1680, 1050);
    };
    return EditorScreen;
  })();
  game.Screen.add('editor', EditorScreen);
  window.cx = canvas.context;
  window.ed = game.Screen.screens.editor;
  return $(function() {
    game.Loop.delta = 1.0 / 60;
    return game.Loop.start();
  });
});