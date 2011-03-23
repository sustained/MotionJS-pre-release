define(['math/vector'], function(Vector) {
  var Canvas;
  Canvas = (function() {
    var DIMENSIONS, _canvasId;
    DIMENSIONS = [[800, 600], [1024, 768], [1280, 1024], [1680, 1050]];
    Canvas.DefaultDimensions = DIMENSIONS[1];
    _canvasId = -1;
    Canvas.prototype.name = null;
    Canvas.prototype.size = Canvas.DefaultDimensions;
    Canvas.prototype.show = true;
    Canvas.prototype.fill = 'white';
    Canvas.prototype.width = 1.0;
    Canvas.prototype.stroke = 'white';
    Canvas.prototype.canvas = null;
    Canvas.prototype.$canvas = null;
    Canvas.prototype.context = null;
    Canvas.prototype.created = false;
    function Canvas(size) {
      var $w, lastResize, resizeMap;
      this.size = size != null ? size : Canvas.DefaultDimensions;
      this.id = ++_canvasId;
      this.name = "motionCanvas" + this.id;
      $w = $(window);
      resizeMap = {
        800: 600,
        1024: 768,
        1280: 1024,
        1680: 1050
      };
      lastResize = 0;
      /*
      			$w.resize (e) =>
      				return if Date.now() - lastResize < 4000
      				w = $w.width()
      				h = $w.height()
      				for size in DIMENSIONS
      					if w is size[0] and h is size[1]
      						@setSize w, h
      						console.log "#{new Date} resizing canvas to supported resolution #{w}x#{h}"
      					else
      						ww = Math.nearest w, 800, 1024, 1280, 1680
      						continue if not ww of resizeMap

      						hh = resizeMap[ww]

      						return if ww is w or hh is h
      						@setSize ww, hh
      						console.log "#{new Date} resizing canvas to nearest supported resolution #{ww}x#{hh}"
      						break
      				lastResize = Date.now()
      				false
      			*/
    }
    Canvas.prototype.draw = function(style) {
      if (style == null) {
        style = {};
      }
      if (style.fill) {
        this.context.fillStyle = style.fill;
        this.context.fill();
      }
      if (style.stroke) {
        this.context.lineWidth = style.width || 1.0;
        this.context.strokeStyle = style.stroke;
        return this.context.stroke();
      }
    };
    Canvas.prototype.lineV = function(position, direction, style) {
      return this.line(position, directioin, style);
    };
    Canvas.prototype.lineA = function(position, direction, style) {
      return this.line(new Vector(position), new Vector(direction), style);
    };
    Canvas.prototype.line = function(position, direction, style) {
      this.context.beginPath();
      this.context.moveTo(position.i, position.j);
      this.context.lineTo(direction.i, direction.j);
      this.context.closePath();
      return this.draw(style);
    };
    Canvas.prototype.point = function(position, style) {
      return this.rectangle(position, [1, 1], style);
    };
    Canvas.CIRC_MODE = 'center';
    Canvas.prototype.circle = function(position, radius, style) {
      if (Canvas.CIRC_MODE === 'corner') {
        position.i -= radius;
        position.j -= radius;
      }
      this.context.beginPath();
      this.context.arc(position.i, position.j, radius, 0, Math.TAU, false);
      this.context.closePath();
      return this.draw(style);
    };
    Canvas.RECT_MODE = 'center';
    Canvas.DEFAULT_FONT = 'Deja Vu Sans Mono';
    Canvas.prototype.text = function(position, text, style) {
      if (style == null) {
        style = {};
      }
      this.context.font = style.font || Canvas.DEFAULT_FONT;
      if (style.align) {
        this.context.textAlign = style.align;
      }
      if (style.base) {
        this.context.textBaseline = style.base;
      }
      if (style.fill) {
        this.context.fillStyle = style.fill;
        this.context.fillText(text, position.i, position.j);
      }
      if (style.stroke) {
        this.context.strokeStyle = stroke.style;
        return this.context.strokeText(text, position.i, position.j);
      }
    };
    Canvas.prototype.rectangle = function(position, dimensions, style) {
      if (style == null) {
        style = {};
      }
      if (style.mode === 'center') {
        position.i -= dimensions[0] / 2;
        position.j -= dimensions[1] / 2;
      }
      if (style.fill) {
        this.context.fillStyle = style.fill;
        this.context.fillRect(position.i, position.j, dimensions[0], dimensions[1]);
      }
      if (style.stroke) {
        this.context.lineWidth = style.width || 1.0;
        this.context.strokeStyle = style.stroke;
        return this.context.strokeRect(position.i, position.j, dimensions[0], dimensions[1]);
      }
    };
    Canvas.prototype.polygon = function(vertices, style) {
      var vertex, _i, _len;
      this.context.beginPath();
      this.context.moveTo(vertices[0].i.round(), vertices[0].j.round());
      for (_i = 0, _len = vertices.length; _i < _len; _i++) {
        vertex = vertices[_i];
        this.context.lineTo(vertex.i.round(), vertex.j.round());
      }
      this.context.lineTo(vertices[0].i.round(), vertices[0].j.round());
      this.context.closePath();
      return this.draw(style);
    };
    Canvas.prototype.create = function(show) {
      this.show = show != null ? show : true;
      if (this.created) {
        return null;
      }
      this.$canvas = $('<canvas>').attr({
        id: this.name,
        width: this.size[0],
        height: this.size[1]
      });
      this.$canvas.css({
        top: this.show ? '0px' : '-10000px',
        left: this.show ? '0px' : '-10000px',
        width: this.size[0] + 'px',
        height: this.size[1] + 'px',
        zIndex: this.id,
        position: 'absolute',
        backgroundColor: '#000000'
      });
      this.$canvas.appendTo('body');
      this.canvas = this.$canvas.get(0);
      this.context = this.canvas.getContext('2d');
      return this.created = true;
    };
    Canvas.prototype.setSize = function(width, height) {
      if (!this.created) {
        return false;
      }
      this.$canvas.attr({
        width: width,
        height: height
      });
      return this.$canvas.css({
        width: width + 'px',
        height: height + 'px'
      });
    };
    Canvas.prototype.validContext = function() {
      return this.context instanceof CanvasRenderingContext2D;
    };
    Canvas.prototype.clear = function() {
      return this.context.clearRect(0, 0, this.size[0], this.size[1]);
    };
    return Canvas;
  })();
  return Canvas;
});