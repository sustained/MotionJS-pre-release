define(['math/vector', 'collision/aabb'], function(Vector, AABB) {
  var Camera;
  Camera = (function() {
    Camera.prototype.entity = null;
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
      if (this.entity) {
                this.position.i = this.entity.body.x - (this.w / 2);
        this.position.j = this.entity.body.y - (this.h / 2);
        this.aabb.setPosition(this.entity.body.position);;
      }
      /*
      			if Game.Input.isKeyDown 'left'
      				@velocity.i += speed
      			else if Game.Input.isKeyDown 'right'
      				@velocity.i -= speed
      			else
      				if @velocity.i.abs() > 0.00005
      					@velocity.i *= 0.8
      				else
      					@velocity.i = 0

      			if Game.Input.isKeyDown 'up'
      				@velocity.j += speed
      			else if Game.Input.isKeyDown 'down'
      				@velocity.j -= speed
      			else
      				if @velocity.j.abs() > 0.00005
      					@velocity.j *= 0.8
      				else
      					@velocity.j = 0

      			@updateVectors dt
      			*/
    };
    Camera.prototype.render = function(canvas) {
      return canvas.rectangle(this.aabb.position.clone(), [this.aabb.w, this.aabb.h], {
        mode: 'center',
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