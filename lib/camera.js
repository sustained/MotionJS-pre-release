define(['math/vector', 'physics/aabb'], function(Vector, AABB) {
  var Camera;
  Camera = (function() {
    Camera.prototype.entity = null;
    function Camera(bounds) {
      if (bounds == null) {
        bounds = [1024, 768];
      }
      this.w = bounds[0];
      this.h = bounds[1];
      this.aabb = new AABB(null, [bounds[0] / 2, bounds[1] / 2]);
      this.position = new Vector;
    }
    Camera.prototype.update = function(delta) {
      if (this.entity) {
        this.position.i = this.entity.body.x - (this.w / 2);
        this.position.j = this.entity.body.y - (this.h / 2);
        return this.aabb.set(this.entity.body.position.clone());
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
      return canvas.rectangle(this.aabb.center.clone(), [this.aabb.hW * 2, this.aabb.hH * 2], {
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