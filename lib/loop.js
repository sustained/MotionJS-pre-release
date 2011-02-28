var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(['motion'], function(Motion) {
  var Loop;
  Loop = (function() {
    Loop.prototype.time = 0;
    Loop.prototype.tick = 0;
    Loop.prototype.tock = 0;
    Loop.prototype.alpha = 0;
    Loop.prototype.delta = 0.016666666666666666;
    Loop.prototype.accum = 0;
    Loop.prototype.update = 0;
    Loop.prototype.render = 0;
    Loop.prototype.gameLoop = null;
    Loop.prototype.frameLoop = null;
    Loop.prototype.context = null;
    Loop.prototype.onUpdate = function() {
      return null;
    };
    Loop.prototype.onRender = function() {
      return null;
    };
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
        this.fpsUpdate.add(this.fpsRender).appendTo('body');
      } else {
        this.frameRate = noop;
      }
      this.time = Date.now();
      this.deltas = [];
      haveGame = isObject(this.Game);
      if (haveGame) {
        this.onUpdate = this.Game.Screen.method('update');
      }
      if (haveGame) {
        this.onRender = this.Game.Screen.method('render');
      }
    }
    Loop.prototype.start = function() {
      this.currentTime = Date.now();
      return this.gameLoop = window.setInterval((__bind(function() {
        return this.loop();
      }, this)), 10);
    };
    Loop.prototype.play = Loop.prototype.start;
    Loop.prototype.stop = function() {
      return window.clearInterval(this.gameLoop);
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
      return this.fpsRender.text('Render @ ' + (1 / (average / length)).toFixed(0) + ' FPS');
    };
    Loop.prototype.loop = function() {
      var delta, time;
      time = Date.now();
      delta = (time - this.time) / 1000;
      if (delta > 0.25) {
        delta = 0.25;
      }
      if (this.deltas.push(delta) > 42) {
        this.deltas = [];
      }
      this.time = time;
      this.accum += delta;
      while (this.accum >= this.delta) {
        this.accum -= this.delta;
        this.update += 1;
        this.tick += this.delta;
        this.onUpdate(this.tick);
      }
      if (this.tick - this.tock > 1) {
        this.tock = this.tick;
        this.frameRate();
        this.lastUpdate = this.update;
      }
      this.alpha = this.accum / this.delta;
      this.render += 1;
      return this.onRender();
    };
    return Loop;
  })();
  return Loop;
});