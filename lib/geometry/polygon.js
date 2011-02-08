var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', 'geometry/shape'], function(Motion, Shape) {
  var Polygon, Vector;
  Vector = Motion.Vector;
  return Polygon = (function() {
    __extends(Polygon, Shape);
    Polygon.createShape = function(sides, radius, position) {
      var angle, i, rotation, vertices;
      if (radius == null) {
        radius = 100;
      }
      if (position == null) {
        position = new Vector;
      }
      if (sides < 3) {
        return false;
      }
      angle = 0;
      rotation = Math.TAU / sides;
      vertices = [];
      i = 0;
      while (i < sides) {
        angle = (i * rotation) + ((Math.PI - rotation) * 0.5);
        vertices.push(new Vector(Math.cos(angle) * radius, Math.sin(angle) * radius));
        i++;
      }
      return new this(vertices, position);
    };
    Polygon.createRectangle = function(width, height, position) {
      var hH, hW;
      hW = width / 2;
      hH = height / 2;
      return new this([new Vector(-hW, -hH), new Vector(hW, -hH), new Vector(hW, hH), new Vector(-hW, hH)], position);
    };
    Polygon.createSquare = function(width, position) {
      return this.createRectangle(width, width, position);
    };
    Polygon.prototype.area = 0;
    Polygon.prototype.center = null;
    Polygon.prototype.offset = null;
    function Polygon(_vertices, position) {
      this._vertices = _vertices != null ? _vertices : [];
      if (position == null) {
        position = new Vector;
      }
      Polygon.__super__.constructor.call(this, position);
      this._axes = [];
      this._verticesT = [];
      this.defineAxes();
    }
    Polygon.get('axes', function() {
      return this._axes;
    });
    Polygon.get('vertices', function() {
      return this._vertices;
    });
    Polygon.get('verticesT', function() {
      var transformed, vert, _i, _len, _ref;
      if (this.transformed === false) {
        transformed = [];
        this.transformed = true;
        _ref = this._vertices;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vert = _ref[_i];
          transformed.push(vert.transform(this.transform));
        }
        this._verticesT = transformed;
      }
      return this._verticesT;
    });
    Polygon.prototype.draw = function(graphics) {
      var vec, verts, _i, _len;
      if (this.fill) {
        graphics.fillStyle = this.fill;
      }
      if (this.stroke) {
        graphics.strokeStyle = this.stroke;
      }
      verts = this.verticesT;
      graphics.beginPath();
      graphics.moveTo(verts[0].i, verts[0].j);
      for (_i = 0, _len = verts.length; _i < _len; _i++) {
        vec = verts[_i];
        graphics.lineTo(vec.i, vec.j);
      }
      graphics.lineTo(verts[0].i, verts[0].j);
      return graphics.closePath();
    };
    Polygon.prototype.defineArea = function() {
      var i, j, l, sum1, sum2;
      sum1 = sum2 = 0;
      i = j = 0;
      l = this.vertices.length;
      while (i < l) {
        j = (i + 1) % l;
        sum1 += this.vertices[i].i * this.vertices[j].j;
        sum2 += this.vertices[i].j * this.vertices[j].i;
        i++;
      }
      return this.area = 0.5 * (sum1 - sum2).abs();
    };
    Polygon.prototype.defineCenter = function() {
      var length, totalX, totalY, vector, _i, _len, _ref;
      totalX = totalY = 0;
      length = this.vertices.length;
      _ref = this.vertices;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vector = _ref[_i];
        totalX += vector.i;
        totalY += vector.j;
      }
      return this.center = new Vector(totalX / length, totalY / length);
    };
    Polygon.prototype.project = function(axis) {
      var i, max, min, num;
      min = axis.dot(this.vertices[0]);
      max = min;
      i = 1;
      while (i < vertsALen) {
        num = axis.dot(this.vertices[i]);
        if (testNum < min1) {
          min = testNum;
        }
        if (testNum > max1) {
          max = testNum;
        }
        i++;
      }
      return [min, max];
    };
    Polygon.prototype.defineAxes = function() {
      var a, b, i, l, _results;
      i = 0;
      l = this.vertices.length;
      _results = [];
      while (i < l) {
        a = this.vertices[i];
        b = this.vertices[++i % l];
        _results.push(this._axes.push(Vector.subtract(b, a).rightNormal().normalize()));
      }
      return _results;
    };
    Polygon.prototype.removeDuplicateAxes = function() {
      var i, j, l;
      i = j = 0;
      l = this.axes.length;
      while (i < l) {
        while (j < l) {
          if (this.axes[i].equals(this.axes[j]) || this.axes[i].equals(Vector.invert(this.axes[j]))) {
            this.axes.splice(j, 1);
          }
          j++;
        }
        i++;
      }
      return;
    };
    return Polygon;
  })();
});