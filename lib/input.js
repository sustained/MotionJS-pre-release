var input;
input = function(Vector, Eventful) {
  var Input, char, code, _ref;
  Input = (function() {
    Input.CHARMAP = {
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
      48: 0,
      49: 1,
      50: 2,
      51: 3,
      52: 4,
      53: 5,
      54: 6,
      55: 7,
      56: 8,
      57: 9,
      65: 'a',
      66: 'b',
      67: 'c',
      68: 'd',
      69: 'e',
      70: 'f',
      71: 'g',
      72: 'h',
      73: 'i',
      74: 'j',
      75: 'k',
      76: 'l',
      77: 'm',
      78: 'n',
      79: 'o',
      80: 'p',
      81: 'q',
      82: 'r',
      83: 's',
      84: 't',
      85: 'u',
      86: 'v',
      87: 'w',
      88: 'x',
      89: 'y',
      90: 'z',
      91: 'lsuper',
      93: 'rsuper'
    };
    Input.CODEMAP = {};
    Input.MOUSEMAP = {
      1: 'left',
      2: 'middle',
      3: 'right'
    };
    Input.codeToChar = function(code) {
      if (code in this.CHARMAP) {
        return this.CHARMAP[code];
      }
    };
    Input.charToCode = function(char) {
      if (char in this.CODEMAP) {
        return this.CODEMAP[char];
      }
    };
    Input.prototype._onKeyDown = function(e) {
      var chr;
      chr = Input.codeToChar(e.which);
      if (chr === false) {
        return false;
      }
      if (this.keyboard[chr] === false) {
        this.keyboard[chr] = true;
        this.altKey = e.altKey;
        this.metaKey = e.metaKey;
        this.shiftKey = e.shiftKey;
        return this.Event.fire('key_down', [chr, e]);
      }
    };
    Input.prototype._onKeyUp = function(e) {
      var chr;
      chr = Input.codeToChar(e.which);
      if (chr === false) {
        return false;
      }
      if (this.keyboard[chr] === true) {
        this.keyboard[chr] = false;
        this.altKey = e.altKey;
        this.metaKey = e.metaKey;
        this.shiftKey = e.shiftKey;
        return this.Event.fire('key_up', [chr, e]);
      }
    };
    Input.prototype._onMouseDown = function(e) {
      var but;
      but = Input.MOUSEMAP[e.which];
      if (this.mouse[but] === false) {
        this.mouse[but] = true;
        return this.Event.fire('mouse_down', [but, e]);
      }
    };
    Input.prototype._onMouseUp = function(e) {
      var but;
      but = Input.MOUSEMAP[e.which];
      if (this.mouse[but] === true) {
        this.mouse[but] = false;
        return this.Event.fire('mouse_up', [but, e]);
      }
    };
    Input.prototype._onMouseMove = function(e) {
      var x, y;
      x = e.pageX;
      y = e.pageY;
      this.mouse.position.page.set(x, y);
      return this.Event.fire('mouse_move', [x, y]);
    };
    Input.prototype.isMouseDown = function(button) {
      return this.mouse[button] === true;
    };
    Input.prototype.isMouseUp = function(button) {
      return this.mouse[button] === false;
    };
    Input.prototype.isKeyDown = function(key) {
      return this.keyboard[key] === true;
    };
    Input.prototype.isKeyUp = function(key) {
      return this.keyboard[key] === false;
    };
    Input.prototype.altKey = false;
    Input.prototype.metaKey = false;
    Input.prototype.shiftKey = false;
    function Input(Game) {
      var char, code, doc, _ref;
      this.Event = new Eventful('key_up', 'key_down', 'mouse_up', 'mouse_down', 'mouse_move');
      this.mouse = {
        left: false,
        right: false,
        scroll: null,
        middle: false,
        position: {
          page: new Vector,
          game: new Vector
        }
      };
      this.keyboard = {};
      this.keyEvents = {};
      _ref = Input.CHARMAP;
      for (code in _ref) {
        char = _ref[code];
        this.keyboard[char] = false;
      }
      doc = $(document);
      doc.bind('oncontextmenu', function(e) {
        return e.preventDefault();
      });
      doc.keyup(this._onKeyUp.bind(this));
      doc.keydown(this._onKeyDown.bind(this));
      doc.mouseup(this._onMouseUp.bind(this));
      doc.mousedown(this._onMouseDown.bind(this));
      doc.mousemove(this._onMouseMove.bind(this));
    }
    return Input;
  })();
  _ref = Input.CHARMAP;
  for (code in _ref) {
    char = _ref[code];
    Input.CODEMAP[char] = code;
  }
  return Input;
};
define(['math/vector', 'eventful'], input);