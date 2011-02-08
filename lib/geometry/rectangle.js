var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', '../math/vector'], function(Motion, Vector) {
  var Rectangle, Square;
  Rectangle = (function() {
    Rectangle.prototype.area = 0;
    Rectangle.prototype.width = 0;
    Rectangle.prototype.height = 0;
    function Rectangle(width, height) {
      this.position = new Vector;
      this.define(width, height);
    }
    Rectangle.prototype.define = function(width, height) {
      this.width = width != null ? width : 0;
      this.height = height != null ? height : 0;
      this.area = this.width * this.height;
      return this;
    };
    Rectangle.prototype.draw = function(pos, ctx) {
      ctx.translate(pos.i, pos.j);
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(this.width, 0);
      ctx.lineTo(this.width, this.height);
      ctx.lineTo(0, this.height);
      ctx.lineTo(0, 0);
      ctx.closePath();
      return ctx.translate(-pos.i, -pos.j);
    };
    return Rectangle;
  })();
  return Square = (function() {
    __extends(Square, Rectangle);
    Square.prototype.size = 0;
    function Square(size) {
      Square.__super__.constructor.call(this, size, size);
    }
    Square.prototype.define = function(size) {
      return Square.__super__.define.call(this, size, size);
    };
    return Square;
  })();
});