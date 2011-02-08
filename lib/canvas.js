var canvas;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
canvas = function(Motion) {
  var Canvas;
  return Canvas = (function() {
    var DIMENSIONS, _canvasId;
    DIMENSIONS = [[800, 600], [1024, 768], [1280, 1024], [1680, 1050]];
    Canvas.DefaultDimensions = DIMENSIONS[1];
    _canvasId = -1;
    Canvas.prototype.name = null;
    Canvas.prototype.size = Canvas.DefaultDimensions;
    Canvas.prototype.show = true;
    Canvas.prototype.canvas = null;
    Canvas.prototype.$canvas = null;
    Canvas.prototype.context = null;
    Canvas.prototype.created = false;
    function Canvas() {
      var $w, lastResize, resizeMap;
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
    Canvas.prototype.create = function() {
      if (this.created) {
        return null;
      }
      this.$canvas = $('<canvas>').attr({
        id: name,
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
      if (this.validContext()) {
        return this.context.clearRect(0, 0, this.size[0], this.size[1]);
      }
    };
    Canvas.prototype.randomPath = function(n, stroke) {
      if (stroke == null) {
        stroke = 'red';
      }
      this.context.beginPath();
      this.context.moveTo(Math.random() * 1000, Math.random * 1000);
      n.times(__bind(function() {
        this.context.lineTo(Math.random() * 1000, Math.random() * 1000);
        return;
      }, this));
      this.context.closePath();
      this.context.strokeStyle = stroke;
      return this.context.stroke();
    };
    return Canvas;
  })();
};
define(['motion'], canvas);