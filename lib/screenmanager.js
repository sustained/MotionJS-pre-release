var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(['motion', 'screen'], function(Motion, Screen) {
  var ScreenManager;
  ScreenManager = (function() {
    __extends(ScreenManager, Motion.Class);
    function ScreenManager(Game) {
      this.Game = Game;
      ScreenManager.__super__.constructor.call(this);
      this.screens = {};
      this.enabled = [];
    }
    ScreenManager.prototype.add = function(name, screen, enable) {
      if (enable == null) {
        enable = true;
      }
      if (!isFunction(screen)) {
        return false;
      }
      screen = new screen(name, this.Game);
      if (!screen instanceof Screen) {
        return false;
      }
      screen.bind('update', this.Game, this.Game.Loop.delta);
      screen.bind('render', this.Game, this.Game.Loop.context);
      this.screens[name] = screen;
      if (enable) {
        this.enabled.push(name);
      }
      return this;
    };
    ScreenManager.prototype.enable = function(name) {
      var i, _i, _len;
      if (isArray(name)) {
        for (_i = 0, _len = name.length; _i < _len; _i++) {
          i = name[_i];
          this.enable(i);
        }
        return;
      }
      this.enabled.push(name);
      return this;
    };
    ScreenManager.prototype.disable = function(name) {
      var i, _i, _len;
      if (isArray(name)) {
        for (_i = 0, _len = name.length; _i < _len; _i++) {
          i = name[_i];
          this.disable(i);
        }
        return;
      }
      if (this.screens[name].persistent === true) {
        return false;
      }
      this.screens[name].tick = 0;
      this.enabled = this.enabled.remove(name);
      return this;
    };
    ScreenManager.prototype.sort = function() {
      return this.enabled = this.enabled.sort(__bind(function(a, b) {
        if (this.screens[a].zIndex > this.screens[b].zIndex) {
          return 1;
        } else {
          return -1;
        }
      }, this));
    };
    ScreenManager.prototype.update = function() {
      var name, _i, _len, _ref;
      _ref = this.enabled;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this.screens[name].update(this.Game.Loop.tick);
        this.screens[name].tick += this.Game.Loop.delta;
      }
      return null;
    };
    ScreenManager.prototype.render = function() {
      var name, _i, _len, _ref;
      _ref = this.enabled;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this.screens[name].render(this.Game.Loop.alpha);
      }
      return null;
    };
    return ScreenManager;
  })();
  return ScreenManager;
});