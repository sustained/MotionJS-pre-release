define(['math/vector', 'collision/aabb'], function(Vector, AABB) {
  var Camera;
  Camera = (function() {
    Camera.prototype.entity = null;
    Camera.prototype.origin = 'center';
    function Camera(bounds) {
      if (bounds == null) {
        bounds = [1024, 768];
      }
      this.hw = (this.w = bounds[0]) / 2;
      this.hh = (this.h = bounds[1]) / 2;
      this.aabb = new AABB(null, {
        t: this.hh,
        b: this.hh,
        l: this.hw,
        r: this.hw
      });
      this.position = new Vector;
    }
    Camera.prototype.update = function(delta) {
      var speed;
      speed = 2;
      if (this.entity) {
        this.position.i = this.entity.body.x - (this.w / 2);
        this.position.j = this.entity.body.y - (this.h / 2);
        return this.aabb.setPosition(this.entity.body.position);
      } else {
        if (game.Input.isKeyDown('left')) {
          this.position.i -= speed;
        } else if (game.Input.isKeyDown('right')) {
          this.position.i += speed;
        }
        if (game.Input.isKeyDown('up')) {
          this.position.j -= speed;
        } else if (game.Input.isKeyDown('down')) {
          this.position.j += speed;
        }
        if (this.origin === 'topleft') {
          return this.aabb.setPosition(Vector.add(this.position, new Vector(this.hw, this.hh)));
        } else if (this.origin === 'center') {
          return this.aabb.setPosition(this.position);
        }
      }
    };
    Camera.prototype.render = function(canvas) {
      return canvas.rectangle(this.position.clone(), [this.aabb.w, this.aabb.h], {
        stroke: 'red',
        width: 5
      });
    };
    Camera.prototype.attach = function(entity) {
      return this.entity = entity;
    };
    return Camera;
  })();
  return Camera;
});