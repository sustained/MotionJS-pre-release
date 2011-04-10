define(['eventful'], function(Eventful) {
  var Keyboard;
  return Keyboard = (function() {
    var code, i, key, _CODEMAP, _KEYMAP, _onKeyDown, _onKeyUp, _setup, _singleton;
    _setup = false;
    _singleton = null;
    Keyboard.instance = function() {
      if (_singleton) {
        return _singleton;
      } else {
        return new this;
      }
    };
    _KEYMAP = {
      8: 'backspace',
      9: 'tab',
      13: 'return',
      16: 'shift',
      17: 'ctrl',
      18: 'alt',
      20: 'caps',
      27: 'esc',
      32: 'space',
      37: 'left',
      38: 'up',
      39: 'right',
      40: 'down',
      91: 'lsuper',
      93: 'rsuper'
    };
    for (i = 0; i < 10; i++) {
      _KEYMAP[48 + i] = i;
    }
    for (i = 0; i < 26; i++) {
      _KEYMAP[65 + i] = String.fromCharCode(97 + i);
    }
    _CODEMAP = {};
    for (code in _KEYMAP) {
      key = _KEYMAP[code];
      _CODEMAP[key] = code;
    }
    _onKeyDown = function(event) {
      if ((key = _KEYMAP[event.which]) === void 0 || this.keys[key] === true) {
        return false;
      }
      this.keys[key] = true;
      return this.event.fire('down', [
        key, {
          alt: (this.altKey = event.altKey),
          ctrl: (this.ctrlKey = event.ctrlKey),
          meta: (this.metaKey = event.metaKey),
          shift: (this.shiftKey = event.shiftKey),
          time: event.timeStamp,
          which: event.which
        }
      ]);
    };
    _onKeyUp = function(event) {
      if ((key = _KEYMAP[event.which]) === void 0 || this.keys[key] === false) {
        return false;
      }
      this.keys[key] = false;
      return this.event.fire('up', [
        key, {
          alt: (this.altKey = event.altKey),
          ctrl: (this.ctrlKey = event.ctrlKey),
          meta: (this.metaKey = event.metaKey),
          shift: (this.shiftKey = event.shiftKey),
          time: event.timeStamp,
          which: event.which
        }
      ]);
    };
    Keyboard.prototype.isKeyDown = function(key) {
      return this.keys[key] === true;
    };
    Keyboard.prototype.isKeyUp = function(key) {
      return this.keys[key] === false;
    };
    Keyboard.prototype.altKey = false;
    Keyboard.prototype.ctrlKey = false;
    Keyboard.prototype.metaKey = false;
    Keyboard.prototype.shiftKey = false;
    function Keyboard() {
      var code, key;
      if (_singleton != null) {
        return _singleton;
      }
      this.event = new Eventful(['up', 'down'], {
        binding: this
      });
      this.keys = {};
      for (code in _KEYMAP) {
        key = _KEYMAP[code];
        this.keys[key] = false;
      }
      _singleton = this;
    }
    Keyboard.prototype.setup = function($el) {
      if (_setup) {
        return;
      }
      $el = $el != null ? $el : $(document);
      $el.keyup(_onKeyUp.bind(this));
      $el.keydown(_onKeyDown.bind(this));
      $(document).bind('contextmenu', function(e) {
        return e.preventDefault();
      });
      return true;
    };
    return Keyboard;
  })();
});