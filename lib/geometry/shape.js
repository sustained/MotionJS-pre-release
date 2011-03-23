define(['classutils'], function(ClassUtils) {
  var BaseShape;
  BaseShape = (function() {
    BaseShape.prototype.area = 0;
    BaseShape.prototype.perimiter = 0;
    BaseShape.prototype._scale = [1, 1];
    BaseShape.prototype._position = null;
    BaseShape.prototype._rotation = 0;
    BaseShape.prototype.transform = null;
    BaseShape.prototype.transformed = false;
    BaseShape.prototype.fill = '';
    BaseShape.prototype.stroke = '';
    function BaseShape(position) {
      if (position == null) {
        position = new Vector;
      }
      this.transform = {
        a: 1,
        b: 0,
        c: 0,
        d: 1
      };
      ({
        tx: 0,
        ty: 0
      });
      this.position = position;
    }
    Motion.extend(BaseShape, ClassUtils.Ext.Accessors);
    BaseShape.set('position', function(_position) {
      this._position = _position;
      this.transform.tx = this._position.i;
      this.transform.ty = this._position.j;
      return this.transformed = false;
    });
    BaseShape.get('position', function() {
      return this._position;
    });
    /*
    		@set 'rotation', (@_rotation) ->
    			@transform.rotate Math.degreesToRadians _rotation
    			@transformed = false

    		@get 'rotation', -> @_rotation

    		@set 'scaleX', (@_scaleX) ->
    			@transform.scale @_scaleX, @_scaleY
    			@transformed = false

    		@get 'scaleX', -> @_scaleX

    		@set 'scaleY', (@_scaleY) ->
    			@transform.scale @_scaleX, @_scaleY
    			@transformed = false

    		@get 'scaleY', -> @_scaleY
    		*/
    BaseShape.set('x', function(x) {
      this._position.i = this.transform.tx = x;
      return this.transformed = false;
    });
    BaseShape.set('y', function(y) {
      this._position.j = this.transform.ty = y;
      return this.transformed = false;
    });
    BaseShape.get('x', function() {
      return this._position.i;
    });
    BaseShape.get('y', function() {
      return this._position.j;
    });
    BaseShape.prototype.draw = function() {
      return null;
    };
    return BaseShape;
  })();
  return BaseShape;
});