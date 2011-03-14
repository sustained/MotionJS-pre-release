var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
require(['client/game', 'entity', 'camera', 'canvas', 'colour', 'math/vector', 'geometry/polygon', 'geometry/circle', 'physics/collision/SAT', 'physics/world', 'physics/aabb', 'screen'], function(Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, AABB, Screen) {
  var $H, $W, $hH, $hW, Blob, GameScreen, MovingBlock, Portal, Wall, boundaries, canvas, coe, cof, game, i, player, rand, wall, walls, world, _i, _j, _len, _len2;
  game = new Game({
    size: [1024, 768],
    delta: 1.0 / 60
  });
  world = game.world;
  canvas = game.canvas;
  world.w = world.h = 25000;
  world.gravity = new Vector(0, 250);
  rand = Math.rand;
  $hW = ($W = 1024) / 2;
  $hH = ($H = 768) / 2;
  Wall = (function() {
    __extends(Wall, Entity.Static);
    function Wall(size) {
      if (size == null) {
        size = [rand(100, 400), rand(20, 40)];
      }
      Wall.__super__.constructor.apply(this, arguments);
      this.body.shape = Polygon.createRectangle(size[0], size[1]);
      this.body.position = new Vector(rand(50, world.w - 50), rand(50, world.h - 50));
      this.body.aabb = new AABB(this.body.position, [size[0] / 2, size[1] / 2]);
    }
    Wall.prototype.render = function(context) {
      var stroke;
      this.body.shape.draw(context);
      return;
      stroke = this.body.colliding ? 'rgba(200, 0, 0, 0.5)' : 'rgba(0, 200, 0, 0.5)';
      return canvas.rectangle(this.body.position.clone(), [this.body.aabb.hW * 2, this.body.aabb.hH * 2], {
        mode: 'center',
        stroke: stroke,
        width: 1
      });
    };
    return Wall;
  })();
  Portal = (function() {
    __extends(Portal, Entity.Dynamic);
    Portal.lastPortalUse = 0;
    function Portal() {
      Portal.__super__.constructor.apply(this, arguments);
      this.event.on('collision', function(collision, entity) {
        if (game.Loop.tick - Portal.lastPortalUse > 0.5) {
          entity.body.position = this.portal.body.position.clone();
          return Portal.lastPortalUse = game.Loop.tick;
        }
      });
      this.body.shape = Polygon.createSquare(32);
    }
    Portal.prototype.render = function(context) {
      return this.body.shape.draw(context);
    };
    return Portal;
  })();
  MovingBlock = (function() {
    __extends(MovingBlock, Entity.Dynamic);
    function MovingBlock() {
      MovingBlock.__super__.constructor.apply(this, arguments);
      this.body.shape = Polygon.createRectangle([100, 20]);
    }
    return MovingBlock;
  })();
  Blob = (function() {
    __extends(Blob, Entity.Dynamic);
    function Blob() {
      Blob.__super__.constructor.apply(this, arguments);
      this.body.maxSpeed = 100000;
      this.body.shape = Polygon.createSquare(26);
      this.body.caabb = new AABB(this.body.position, [250, 250]);
      this.body.aabb.set(this.body.position, [13, 13]);
      this.event.on('collision', function(collision, entity) {
        if (collision.vector.j === 1) {
          return this.groundBelow = true;
        }
      });
    }
    Blob.prototype.jump = false;
    Blob.prototype.blink = false;
    Blob.prototype.endBlink = 0;
    Blob.prototype.startJump = 0;
    Blob.prototype.startBlink = 0;
    Blob.prototype.facingLeft = false;
    Blob.prototype.facingRight = true;
    Blob.prototype.jumpEnd = 0;
    Blob.prototype.jumpLoops = 0;
    Blob.prototype.jumpStartAllowed = false;
    Blob.prototype.groundBelow = false;
    Blob.prototype.jumpLastImpulse = 0;
    Blob.prototype.jumpTicker = 0;
    Blob.prototype.input = function(input) {
      var change, hMovement;
      change = 2;
      hMovement = false;
      if (input.isKeyDown('a')) {
        hMovement = true;
        this.facingLeft = !(this.facingRight = false);
        this.body.applyForce(new Vector(-150, 0));
      } else if (input.isKeyDown('d')) {
        hMovement = true;
        this.facingRight = !(this.facingLeft = false);
        this.body.applyForce(new Vector(150, 0));
      } else {
        if (this.groundBelow) {
          if (this.body.velocity.i.abs() > 0.0001) {
            this.body.velocity.i *= 0.98;
          } else {
            this.body.velocity.i = 0;
          }
        }
      }
      if (!this.groundBelow) {
        if (this.body.velocity.i.abs() > 0.0001) {
          this.body.velocity.i *= 0.98;
        } else {
          this.body.velocity.i = 0;
        }
      }
      if (input.isKeyDown('w') && this.groundBelow) {
        this.body.applyForce(new Vector(0, -4000));
      }
      if (!this.colliding) {
        this.groundBelow = false;
      }
      return;
      if (this.jumpAllowed === true) {
        if (input.isKeyDown('space') || input.isKeyDown('w')) {
          if (game.Loop.tick - this.jumpLastImpulse > 0.1) {
            if (++this.jumpLoops < 10) {
              this.jumpLastImpulse = game.Loop.tick;
              return this.body.applyForce(new Vector(0, -(2000 * this.jumpLoops)));
            } else {
              this.jumpEnd = game.Loop.tick;
              this.jumpLoops = 0;
              return this.jumpAllowed = false;
            }
          }
        }
      } else {
        if (game.Loop.tick - this.jumpEnd > 2.0) {
          return this.jumpAllowed = true;
        }
      }
    };
    Blob.prototype.update = function(tick) {
      var vel;
      vel = this.body.velocity.clone().abs().multiply(2);
      if (vel.i < 50) {
        vel.i = 50;
      }
      if (vel.j < 50) {
        vel.j = 50;
      }
      this.body.caabb.set(this.body.position.clone(), [vel.i, vel.j]);
      /*
      			@body.caabb.hW = 25
      			@body.caabb.hH = 25

      			pos  = @body.position.clone()
      			@body.caabb.center = pos

      			@body.caabb.setR Math.max 25, vel.i
      			@body.caabb.setL Math.max 25, Math.abs vel.i

      			@body.caabb.setB Math.max 25, vel.j
      			@body.caabb.setT Math.max 25, Math.abs vel.j
      			*/
      if (this.blink === false) {
        if (tick - this.endBlink > 4) {
          this.blink = true;
          return this.startBlink = tick;
        }
      } else {
        if (tick - this.startBlink > 0.25) {
          this.blink = false;
          return this.endBlink = tick;
        }
      }
    };
    Blob.prototype.drawBlob = function() {
      canvas.circle(this.body.position.clone(), 16, {
        fill: 'rgb(180, 180, 0)'
      });
      if (this.jumpTicker > 0) {
        canvas.rectangle(Vector.add(this.body.position, new Vector(50, 0)), [4, 20], {
          stroke: 'gray'
        });
        canvas.rectangle(Vector.add(this.body.position, new Vector(50, 20)), [4, -this.jumpTicker], {
          fill: 'red'
        });
      }
      return canvas.text(Vector.add(this.body.position, new Vector(50, 50)), this.body.velocity.length().toFixed(0), {
        font: '12px Helvetica Neue',
        fill: 'white'
      });
    };
    Blob.prototype.drawEyes = function() {
      var j;
      if (this.blink) {
        j = this.body.y - 4;
        if (this.facingLeft) {
          return canvas.line(new Vector(this.body.x - 14, j), new Vector(this.body.x - 4, j), {
            stroke: 'black',
            width: 0.5
          });
        } else if (this.facingRight) {
          return canvas.line(new Vector(this.body.x + 14, j), new Vector(this.body.x + 4, j), {
            stroke: 'black',
            width: 0.5
          });
        }
      } else {
        if (this.facingLeft) {
          canvas.circle(new Vector(this.body.x - 8, this.body.y - 4), 7, {
            fill: 'white'
          });
          return canvas.point(new Vector(this.body.x - 12, this.body.y - 5), {
            fill: 'black'
          });
        } else if (this.facingRight) {
          canvas.circle(new Vector(this.body.x + 8, this.body.y - 4), 7, {
            fill: 'white'
          });
          return canvas.point(new Vector(this.body.x + 12, this.body.y - 5), {
            fill: 'black'
          });
        }
      }
    };
    Blob.prototype.drawMouth = function() {
      var j;
      j = this.body.y + 10;
      if (this.facingLeft) {
        return canvas.line(new Vector(this.body.x - 12, j), new Vector(this.body.x - 2, j), {
          stroke: 'black',
          width: 0.5
        });
      } else if (this.facingRight) {
        return canvas.line(new Vector(this.body.x + 12, j), new Vector(this.body.x + 2, j), {
          stroke: 'black',
          width: 0.5
        });
      }
    };
    Blob.prototype.drawAABB = function() {
      var stroke;
      stroke = this.body.colliding ? 'rgba(200, 0, 0, 0.5)' : 'rgba(0, 200, 0, 0.5)';
      canvas.rectangle(this.body.position.clone(), [this.body.aabb.hW * 2, this.body.aabb.hH * 2], {
        mode: 'center',
        stroke: stroke,
        width: 1
      });
      return canvas.rectangle(this.body.position.clone(), [this.body.caabb.hW * 2, this.body.caabb.hH * 2], {
        mode: 'center',
        stroke: 'rgba(0, 200, 0, 0.3)'
      });
    };
    Blob.prototype.render = function(context) {
      this.drawBlob();
      this.drawEyes();
      return this.drawMouth();
    };
    return Blob;
  })();
  player = new Blob;
  player.body.position = new Vector($hW, 100);
  world.groups.player[player.id] = player;
  world.addEntity(player);
  walls = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 10000; i++) {
      wall = new Wall;
      coe = 0.25;
      cof = 0;
      wall.body.coe = coe;
      wall.body.cof = cof;
      wall.body.shape.fill = new Colour(0, 200, 0, wall.body.coe).rgb();
      wall.body.shape.stroke = new Colour(200, 0, 0, wall.body.cof).rgb();
      _results.push(wall);
    }
    return _results;
  })();
  boundaries = [new Wall([world.w, 20]), new Wall([world.w, 20]), new Wall([20, world.h]), new Wall([20, world.h])];
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
  walls = walls.concat(boundaries);
  for (_j = 0, _len2 = walls.length; _j < _len2; _j++) {
    wall = walls[_j];
    world.addEntity(wall);
  }
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
  /*
  	class Renderer
  		@create: (render) -> render.bind canvas.context

  	EditorPolyShapeRenderer = Renderer.create (shape) ->
  		verts = shape.verticesT

  		@beginPath()
  		@moveTo verts[0].i, verts[0].j
  		@lineTo vertex.i, vertex.j for vertex in verts
  		@lineTo verts[0].i, verts[0].j
  		@closePath()

  		if shape.fill
  			@fillStyle = shape.fill
  			@fill()

  		if shape.stroke
  			@strokeStyle = shape.stroke
  			@stroke()

  	EditorCollRenderer = Renderer.create (shape) ->
  		EditorPolyShapeRenderer shape

  		@fillStyle = 'white'
  		@fillText 'Collision Block', shape.x, shape.y

  	EditorTrigRenderer = Renderer.create (shape) ->
  		EditorPolyShapeRenderer shape

  		@fillStyle = 'white'
  		@fillText 'Trigger', shape.x, shape.y

  	EditorRectShapeRenderer = Renderer.create (shape) ->

  	EditorCircShapeRenderer = Renderer.create (shape) ->
  		@beginPath()
  		@arc shape.position.i, shape.position.j, shape.radiusT, 0, Math.TAU, false
  		@closePath()

  		if shape.fill
  			@fillStyle = shape.fill
  			@fill()

  		if shape.stroke
  			@strokeStyle = shape.stroke
  			@stroke()

  	EditorPlayerRenderer = Renderer.create (player) ->
  		@fillStyle = 'red'
  		@fillRect player.x - 13, player.y - 13, 26, 26

  	class EditorScreen extends Motion.Screen
  		constructor: ->
  			super

  		blur:  -> console.log 'editor screen blurred'
  		focus: ->
  			console.log 'editor screen focused'

  			strokeColour = new Colour(0, 0, 200).rgb()
  			fillColour   = new Colour(0, 0, 150, 0.6).rgba()

  			for shape in world.shapes
  				shape.fill   = fillColour
  				shape.stroke = strokeColour

  			strokeColour = new Colour(0, 255, 0).rgb()

  			for trigger in world.triggers
  				trigger.fill   = false
  				trigger.stroke = strokeColour

  		update: (Game, delta, tick) ->

  		render: (Game, context) ->
  			context.clearRect 0, 0, 1024, 768

  			EditorPlayerRenderer world.player

  			for shape in world.shapes
  				EditorCollRenderer shape

  			for trigger in world.triggers
  				EditorTrigRenderer trigger
  	*/
  game.Screen.add('game', GameScreen, true);
  window.world = world;
  return $(function() {
    return game.Loop.start();
  });
});
/*
e.colliding = false

for shape, i in world.shapes
	test = SAT.test shape, world.player.shape
	done = false

	if test
		if shape.fill is 'blue'
			if tick - @lastPortalUse > 0.5
				e.position     = shape.portal.position.clone()
				@lastPortalUse = tick
			break

		e.colliding = true

		#@shapes[i].stroke = Colour.get('red').rgba()
		#hits++
		log "#{test.vector}\t#{test.overlap.toFixed(2)}"
		#console.log "Separation: #{test.separation}"
		#console.log "Unit Vector: #{test.unitVector}"
		#console.log e.acceleration.debug()

		e.position = e.position.add test.separation

		#if test.vector.i > 0
		#	cof = 0.3

		if test.vector.j is 1
			e.jump = false if e.jump
		#Vn = (V . N) * N;
		#Vt = V – Vn;
		#V’ = Vt * (1 – friction) + Vn  * -(elasticity);

		vn = Vector.multiply test.vector, e.velocity.dot(test.vector)
		vt = Vector.subtract e.velocity, vn

		#console.log vt.length()

		#console.log vt.debug()
		#if vt.length() < 10
		#	vt = Vector.multiply vt, 0.98

		#if vt.length() < 0.5
		#	cof = 1.01

		v  = Vector.add Vector.multiply(vt, 1 - cof), Vector.multiply(vn, -coe)
		e.velocity = v
		#e.acceleration.j = 0
		#e.velocity.j     = 0

		#console.log test.vector.debug()
		#e.velocity.add Vector.multiply test.separation, 100
		#e.force.add Vector.multiply test.separation, 100
	else
		#@shapes[i].stroke = Colour.get('green').rgba()
*/
/*
@map = [
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1]
	[1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
	[1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1]
	[1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
]
@mapWidth  = @map[0].length
@mapHeight = @map.length
*/