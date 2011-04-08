var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function() {
  var Loop;
  return Loop = (function() {
    var _logger;
    Loop.prototype.time = 0;
    Loop.prototype.tick = 0;
    Loop.prototype.tock = 0;
    Loop.prototype.alpha = 0;
    Loop.prototype.delta = 1.0 / 60;
    Loop.prototype.accum = 0;
    Loop.prototype.update = 0;
    Loop.prototype.lastUpdate = 0;
    Loop.prototype.render = 0;
    Loop.prototype.gameLoop = null;
    Loop.prototype.frameLoop = null;
    Loop.prototype.context = null;
    Loop.prototype._onUpdate = function() {};
    Loop.prototype._onRender = function() {};
    function Loop(Game) {
      var css, haveGame;
      this.Game = Game;
      if (Motion.env === 'client') {
        this.fpsUpdate = $('<p />');
        this.fpsRender = $('<p />');
        css = {
          position: 'absolute',
          zIndex: 9999,
          background: '#121212',
          border: '2px solid #040404',
          fontFamily: 'sans-serif',
          color: '#b3b3b3',
          fontWeight: 'normal',
          margin: '0px',
          padding: '3px',
          height: '16px',
          lineHeight: '16px'
        };
        this.fpsUpdate.css(css).css({
          top: '10px',
          left: '10px'
        }).attr('id', 'fpsUpdate');
        this.fpsRender.css(css).css({
          top: '45px',
          left: '10px'
        }).attr('id', 'fpsRender');
        this.fpsUpdate.add(this.fpsRender).appendTo('body').hide();
      } else {
        this.frameRate = function() {
          return null;
        };
      }
      this.time = Date.now();
      this.deltas = [];
      if (Motion.env === 'client') {
        haveGame = isObject(this.Game);
        if (haveGame) {
          this.onUpdate(this.Game.Screen.method('update'));
        }
        if (haveGame) {
          this.onRender(this.Game.Screen.method('render'));
        }
      }
    }
    Loop.prototype.onUpdate = function(update) {
      return this._onUpdate = update.bind(update, [this.delta]);
    };
    Loop.prototype.onRender = function(render) {
      return this._onRender = render.bind(render, [this.context]);
    };
    Loop.prototype.start = function() {
      this.currentTime = Date.now();
      return this.gameLoop = setInterval((__bind(function() {
        return this.loop();
      }, this)), 10);
    };
    Loop.prototype.play = Loop.prototype.start;
    Loop.prototype.stop = function() {
      return clearInterval(this.gameLoop);
    };
    Loop.prototype.pause = Loop.prototype.stop;
    Loop.prototype.reset = function() {
      return this.time = this.tick = this.tock = this.accum = this.update = this.render = 0;
    };
    Loop.prototype.showFPS = function() {
      this.showFPS = true;
      return this.fpsUpdate.add(this.fpsRender).show();
    };
    Loop.prototype.hideFPS = function() {
      this.showFPS = false;
      return this.fpsUpdate.add(this.fpsRender).hide();
    };
    Loop.prototype.frameRate = function() {
      var average, length;
      if (this.showFPS === false) {
        return;
      }
      length = this.deltas.length;
      average = this.deltas.sum();
      this.fpsUpdate.text('Update @ ' + (this.update - this.lastUpdate) + ' FPS');
      if (length === 0) {
        return;
      }
      return this.fpsRender.text('Render @ ' + (1 / (average / length)).toFixed(0) + ' FPS');
    };
    _logger = new Logger(100);
    Loop.prototype.fps = 0;
    Loop.prototype.loop = function() {
      var delta, time;
      time = Date.now();
      delta = (time - this.time) / 1000;
      if (delta > 0.25) {
        delta = 0.25;
      }
      if (this.update % 15 === 0) {
        this.fps = 1.0 / delta;
      }
      this.time = time;
      this.accum += delta;
      while (this.accum >= this.delta) {
        this._onUpdate(this.tick);
        this.tick += this.delta;
        this.accum -= this.delta;
        this.update += 1;
      }
      this.alpha = this.accum / this.delta;
      this._onRender(this.alpha);
      return this.render += 1;
    };
    return Loop;
  })();
});