var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(function() {
  var Matrix, Matrix2x2, Matrix3x3;
  Matrix = (function() {
    function Matrix() {}
    Matrix.prototype.height = function() {
      return this.m.length;
    };
    Matrix.prototype.width = function() {
      return this.m[0].length;
    };
    Matrix.prototype.isColumn = function() {
      return this.m[0].length === 1 && this.m.length > 1;
    };
    Matrix.prototype.isRow = function() {
      return this.m.length === 1 && this.m[0].length > 1;
    };
    Matrix.prototype.isSquare = function() {
      return this.height() === this.width();
    };
    return Matrix;
  })();
  Matrix2x2 = (function() {
    __extends(Matrix2x2, Matrix);
    Matrix2x2.Identity = new Matrix2x2([[1, 0], [0, 1]]);
    Matrix2x2.Zero = new Matrix2x2([[0, 0], [0, 0]]);
    function Matrix2x2(m) {
      this.m = m != null ? m : this.Identity;
      Matrix2x2.__super__.constructor.call(this);
    }
    Matrix2x2.prototype.add = function() {};
    Matrix2x2.prototype.subtract = function() {};
    Matrix2x2.prototype.multiply = function(x) {
      if (isArray(x)) {} else {
        this.m = [[this.m[0][0] * s, this.m[0][1] * s], [this.m[1][0] * s, this.m[1][1] * s]];
      }
      return this.m;
    };
    return Matrix2x2;
  })();
  return Matrix3x3 = (function() {
    __extends(Matrix3x3, Matrix);
    Matrix3x3.Identity = new Matrix3x3([[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
    Matrix3x3.Zero = new Matrix3x3([[0, 0, 0], [0, 0, 0], [0, 0, 0]]);
    function Matrix3x3(m) {
      this.m = m != null ? m : this.Identity;
      Matrix3x3.__super__.constructor.call(this);
    }
    return Matrix3x3;
  })();
});