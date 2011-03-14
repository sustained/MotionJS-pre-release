var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require(['client/game', 'entity', 'camera', 'canvas', 'colour', 'math/vector', 'geometry/polygon', 'geometry/circle', 'physics/collision/SAT', 'physics/world', 'physics/aabb', 'screen'], function(Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, AABB, Screen) {
  var $H, $W, $hH, $hW, EditorScreen, canvas, game, rand, world;
  game = new Game;
  rand = Math.rand;
  world = game.world;
  canvas = game.canvas;
  $hW = ($W = 1024) / 2;
  $hH = ($H = 768) / 2;
  world.gravity = new Vector(0, 0);
  /*
  	socket = new io.Socket 'localhost', port: 8080
  	console.log socket

  	socket.on 'connect', ->
  		console.log 'connected'

  	socket.on 'message', (msg) ->
  		console.log "message #{msg}"

  	socket.on 'disconnect', ->
  		console.log 'disconnected'

  	socket.connect()
  	*/
  EditorScreen = (function() {
    __extends(EditorScreen, Screen);
    function EditorScreen() {
      EditorScreen.__super__.constructor.apply(this, arguments);
      this.run = true;
      this.camera = new Camera([$W, $H], {
        moveable: true
      });
      this.xLines = $W / 4;
      this.yLines = $H / 4;
    }
    EditorScreen.prototype.input = function(Input) {
      if (Input.isKeyDown('left')) {
        this.camera.position.i -= 2;
      } else if (Input.isKeyDown('right')) {
        this.camera.position.i += 2;
      }
      if (Input.isKeyDown('up')) {
        return this.camera.position.j -= 2;
      } else if (Input.isKeyDown('down')) {
        return this.camera.position.j += 2;
      }
    };
    EditorScreen.prototype.update = function(delta, tick) {
      this.input(game.Input);
      if (this.run) {
        world.step(delta);
      }
      this.camera.update(delta);
      return game.Input.update(this.camera);
    };
    EditorScreen.prototype.render = function(context) {
      var x, xl, y, yl;
      canvas.clear();
      context.translate(-this.camera.position.i, -this.camera.position.j);
      context.font = '10px "Helvetica CY"';
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      canvas.text(new Vector(0, 0), '0', {
        fill: 'lightgray'
      });
      x = 1;
      xl = 1024 / 32;
      while (x <= xl) {
        canvas.text(new Vector(x * 32, 10), x * 32, {
          fill: 'lightgray'
        });
        x++;
      }
      y = 1;
      yl = 768 / 32;
      while (y <= yl) {
        canvas.text(new Vector(10, y * 32), y * 32, {
          fill: 'lightgray'
        });
        y++;
      }
      /*
      			x = 0; xl = 1024 / 32; while x <= xl
      				y = 0; yl = 768 / 32; while y <= yl
      					canvas.rectangle new Vector(x * 32, y * 32), [32, 32],
      						fill: if x & 1
      							if y & 1 then '#050505' else '#101010'
      						else
      							if y & 1 then '#101010' else '#050505'

      					canvas.text new Vector((x * 32) - 16, (y * 32) - 16), "#{x} , #{y}", fill: '#bdbdbd'

      					y++

      				x++
      			*/
      world.render(context, this.camera);
      return context.translate(this.camera.position.i, this.camera.position.j);
    };
    return EditorScreen;
  })();
  game.Screen.add('editor', EditorScreen, true);
  return $(function() {
    return game.Loop.start();
  });
});