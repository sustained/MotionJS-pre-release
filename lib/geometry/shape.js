define(['motion'], function(Motion) {
  var BaseShape, Vector;
  Vector = Motion.Vector;
  BaseShape = (function() {
    BaseShape.Types = {
      STATIC: 0 << 0,
      DYNAMIC: 0 << 1
    };
    BaseShape.prototype.type = null;
    BaseShape.prototype._scaleX = 1;
    BaseShape.prototype._scaleY = 1;
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
        d: 1,
        tx: 0,
        ty: 0
      };
      this.position = position;
    }
    extend(BaseShape, Motion.ClassUtils.Ext.Accessors);
    BaseShape.set('position', function(_position) {
      this._position = _position;
      this.transform.tx = this._position.i;
      this.transform.ty = this._position.j;
      return this.transformed = false;
    });
    BaseShape.get('position', function() {
      return this._position;
    });
    BaseShape.set('rotation', function(_rotation) {
      this._rotation = _rotation;
      this.transform.rotate(Math.degreesToRadians(_rotation));
      return this.transformed = false;
    });
    BaseShape.get('rotation', function() {
      return this._rotation;
    });
    BaseShape.set('scaleX', function(_scaleX) {
      this._scaleX = _scaleX;
      this.transform.scale(this._scaleX, this._scaleY);
      return this.transformed = false;
    });
    BaseShape.get('scaleX', function() {
      return this._scaleX;
    });
    BaseShape.set('scaleY', function(_scaleY) {
      this._scaleY = _scaleY;
      this.transform.scale(this._scaleX, this._scaleY);
      return this.transformed = false;
    });
    BaseShape.get('scaleY', function() {
      return this._scaleY;
    });
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
    BaseShape.prototype.draw = noop;
    return BaseShape;
  })();
  return BaseShape;
});