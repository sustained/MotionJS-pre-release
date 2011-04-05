define(['eventful'], function(Eventful) {
  var Keyboard;
  return Keyboard = (function() {
    var code, i, key, _CODEMAP, _KEYMAP, _onKeyDown, _onKeyUp, _setup, _singleton;
    _setup = false;
    _singleton = null;
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
    console.log(_KEYMAP);
    /*
    			48:  0
    			49:  1
    			50:  2
    			51:  3
    			52:  4
    			53:  5
    			54:  6
    			55:  7
    			56:  8
    			57:  9
    			65: 'a'
    			66: 'b'
    			67: 'c'
    			68: 'd'
    			69: 'e'
    			70: 'f'
    			71: 'g'
    			72: 'h'
    			73: 'i'
    			74: 'j'
    			75: 'k'
    			76: 'l'
    			77: 'm'
    			78: 'n'
    			79: 'o'
    			80: 'p'
    			81: 'q'
    			82: 'r'
    			83: 's'
    			84: 't'
    			85: 'u'
    			86: 'v'
    			87: 'w'
    			88: 'x'
    			89: 'y'
    			90: 'z'
    		*/
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
          alt: event.altKey,
          ctrl: event.ctrlKey,
          meta: event.metaKey,
          shift: event.shiftKey,
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
          alt: event.altKey,
          ctrl: event.ctrlKey,
          shift: event.shiftKey,
          meta: event.metaKey,
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
      return true;
    };
    return Keyboard;
  })();
});