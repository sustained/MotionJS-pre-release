define(['eventful'], function(Eventful) {
  var Mouse, Vector;
  Vector = Math.Vector;
  return Mouse = (function() {
    var _MAP, _onMouseDown, _onMouseMove, _onMouseUp, _setup, _singleton;
    _setup = false;
    _singleton = null;
    Mouse.instance = function() {
      if (_singleton) {
        return _singleton;
      } else {
        return new this;
      }
    };
    _MAP = {
      1: 'left',
      2: 'middle',
      3: 'right'
    };
    _onMouseDown = function(e) {
      var button;
      button = _MAP[e.which];
      if (this[button] === false) {
        this[button] = true;
        return this.event.fire('down', [button, e]);
      }
    };
    _onMouseUp = function(e) {
      var button;
      button = _MAP[e.which];
      if (this[button] === true) {
        this[button] = false;
        return this.event.fire('up', [button, e]);
      }
    };
    _onMouseMove = function(e) {
      return this.position.set(e.pageX, e.pageY);
    };
    Mouse.prototype.position = null;
    Mouse.prototype.left = false;
    Mouse.prototype.right = false;
    Mouse.prototype.middle = false;
    Mouse.prototype.lastUpdate = 0;
    Mouse.prototype.waitInterval = 1.0 / 60;
    Mouse.prototype.isMouseDown = function(button) {
      return this.mouse[button] === true;
    };
    Mouse.prototype.isMouseUp = function(button) {
      return this.mouse[button] === false;
    };
    function Mouse() {
      if (_singleton != null) {
        return _singleton;
      }
      this.event = new Eventful(['down', 'up'], {
        binding: this
      });
      this.position = new Vector;
      _singleton = this;
    }
    Mouse.prototype.inCamera = function(camera) {
      return Vector.add(camera.position, this.position);
    };
    Mouse.prototype.setup = function($el) {
      $el = $el != null ? $el : $(document);
      $el.mouseup(_onMouseUp.bind(this));
      $el.mousedown(_onMouseDown.bind(this));
      return $el.mousemove(_onMouseMove.bind(this));
    };
    return Mouse;
  })();
});