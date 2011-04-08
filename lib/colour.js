define(function() {
  var Colour;
  return Colour = (function() {
    /*
    		#	Create common colours...
    		*/    Colour.setup = function() {
      this.create('white', 255, 255, 255);
      this.create('black', 0, 0, 0);
      this.create('red', 255, 0, 0);
      this.create('green', 0, 255, 0);
      this.create('blue', 0, 0, 255);
      return this.create('yellow', 255, 255, 0);
    };
    Colour.ALPHA = [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1];
    Colour.DEFAULT_ALPHA = 1.0;
    Colour.random = function(rgba) {
      var random;
      if (rgba == null) {
        rgba = true;
      }
      random = new Colour(Math.rand(0, 255), Math.rand(0, 255), Math.rand(0, 255), Colour.ALPHA.random());
      if (rgba === true) {
        return random.rgba();
      } else {
        return random;
      }
    };
    Colour.colours = {};
    Colour.create = function(name, r, g, b, a) {
      if (!this.get(name)) {
        this.colours[name] = new this(r, g, b, a);
      }
      return this.colours[name];
    };
    Colour.get = function(name) {
      var _ref;
      return (_ref = this.colours[name]) != null ? _ref : false;
    };
    Colour.prototype.parts = [];
    function Colour(r, g, b, a) {
      if (r == null) {
        r = 0;
      }
      if (g == null) {
        g = 0;
      }
      if (b == null) {
        b = 0;
      }
      if (a == null) {
        a = Colour.DEFAULT_ALPHA;
      }
      if (isArray(r) && this.parts.length >= 3) {
        this.parts = r;
        if (this.parts.length < 4) {
          this.parts.push(a);
        }
      } else {
        this.parts = [r, g, b, a];
      }
    }
    Colour.prototype.r = function(r) {
      this.parts[0] = r;
      return this;
    };
    Colour.prototype.g = function(g) {
      this.parts[1] = g;
      return this;
    };
    Colour.prototype.b = function(b) {
      this.parts[2] = b;
      return this;
    };
    Colour.prototype.a = function(a) {
      this.parts[3] = a;
      return this;
    };
    Colour.prototype.lighter = function() {};
    Colour.prototype.darker = function() {};
    Colour.prototype.rgb = function() {
      return "rgb(" + (this.parts.slice(0, 3).join(', ')) + ")";
    };
    Colour.prototype.rgba = function() {
      return "rgba(" + (this.parts.join(', ')) + ")";
    };
    Colour.prototype.toString = Colour.prototype.rgba;
    Colour.prototype.copy = function() {
      return new Colour(this.parts[0], this.parts[1], this.parts[2], this.parts[3]);
    };
    Colour.prototype.duplicate = Colour.prototype.copy;
    return Colour;
  })();
});