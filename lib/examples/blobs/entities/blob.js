var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['entity', 'math/vector', 'geometry/polygon', 'geometry/rectangle', 'collision/aabb', 'behaviours/clickable', 'behaviours/draggable'], function(Entity, Vector, Polygon, Rectangle, AABB, BClickable, BDraggable) {
  var Blob;
  Blob = (function() {
    __extends(Blob, Entity.Dynamic);
    Blob.prototype.health = 500;
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
    Blob.prototype.groundBelow = true;
    Blob.prototype.jumpLastImpulse = 0;
    Blob.prototype.jumpTicker = 0;
    Blob.prototype.keys = {};
    Blob.prototype.hover = function() {};
    Blob.prototype.click = function() {};
    Blob.prototype.input = function(input) {
      var change, hMovement;
      change = 2;
      hMovement = false;
      if (input.isKeyDown('p') && this.body.velocity.j >= 100) {
        this.body.applyForce(new Vector(0, -350));
      }
      if (input.isKeyDown(this.keys.l)) {
        hMovement = true;
        this.facingLeft = !(this.facingRight = false);
        this.body.applyForce(new Vector(-150, 0));
      } else if (input.isKeyDown(this.keys.r)) {
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
      if (input.isKeyDown(this.keys.j) && this.groundBelow) {
        this.body.applyForce(new Vector(0, -7500));
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
    Blob.prototype.collide = function(collision, entity) {
      var len, max, min;
      if (entity.collideType === 0x1) {
        if (collision.vector.j === 1) {
          this.groundBelow = true;
        }
      }
      if (entity.collideType === 0x2) {
        if (collision.vector.j === 1) {
          this.groundBelow = true;
        }
      }
      if (entity.collideType === 0x4) {
        console.log('powerup!');
        return false;
      }
      len = this.body.velocity.lengthSquared();
      min = 90000;
      max = 1000000;
      if (len >= min) {
        this.health -= Math.remap(len, [min, max], [0, 500]);
      }
      return true;
    };
    Blob.prototype.update = function(tick) {
      var vel;
      Blob.__super__.update.call(this);
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
      this.body.caabb.setPosition(this.body.position);
      /*
      			vel = @body.velocity.clone().abs().multiply 2#.divide 2

      			if vel.i < 50 then vel.i = 50
      			if vel.j < 50 then vel.j = 50

      			@body.caabb.set @body.position.clone(), [vel.i, vel.j]

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
      canvas.text(Vector.add(this.body.position, new Vector(50, 40)), "Vel2: " + (this.body.velocity.lengthSquared().toFixed(0)), {
        font: '12px Helvetica Neue',
        fill: 'white'
      });
      canvas.text(Vector.add(this.body.position, new Vector(50, 20)), "|Vel|: " + (this.body.velocity.length().toFixed(0)), {
        font: '12px Helvetica Neue',
        fill: 'white'
      });
      return canvas.text(Vector.add(this.body.position, new Vector(50, 0)), "Health: " + (this.health.toFixed(0)), {
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
      canvas.rectangle(this.body.position.clone(), [this.body.aabb.hw * 2, this.body.aabb.hh * 2], {
        mode: 'center',
        stroke: stroke,
        width: 1
      });
      return canvas.polygon([new Vector(this.body.caabb.l, this.body.caabb.t), new Vector(this.body.caabb.r, this.body.caabb.t), new Vector(this.body.caabb.r, this.body.caabb.b), new Vector(this.body.caabb.l, this.body.caabb.b)], {
        stroke: 'rgba(0, 255, 0, 0.5)'
        /*
        			canvas.rectangle \
        				@body.position.clone(),
        				[@body.caabb.hW * 2, @body.caabb.hH * 2],
        				mode: 'center', stroke: 'rgba(0, 200, 0, 0.3)'
        			*/
      });
    };
    Blob.prototype.render = function(context) {
      this.drawBlob();
      this.drawEyes();
      this.drawMouth();
      return this.drawAABB();
    };
    function Blob() {
      Blob.__super__.constructor.apply(this, arguments);
      this.game = new (require('client/game'));
      if (this.input != null) {
        this.input = this.input.bind(this, this.game.Input);
      }
      this.addBehaviour('clickable', BClickable);
      this.collideType = 0x1;
      this.collideWith = 0x1 | 0x2 | 0x4;
      this.body.coe = 1.0;
      this.body.cof = 0.0;
      this.body.maxSpeed = 1000;
      this.body.shape = Polygon.createRectangle(26, 26);
      this.body.caabb = new AABB(this.body.position, 50);
      this.body.aabb.set(this.body.position, 13);
    }
    return Blob;
  })();
  return Blob;
});