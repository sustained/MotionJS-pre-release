var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(['class', 'screen'], function(Class, Screen) {
  var ScreenManager;
  return ScreenManager = (function() {
    __extends(ScreenManager, Class);
    ScreenManager.prototype.focus = true;
    function ScreenManager(game) {
      this.game = game;
      ScreenManager.__super__.constructor.call(this);
      $(window).focus(__bind(function() {
        return this.focus = true;
      }, this));
      $(window).blur(__bind(function() {
        return this.focus = false;
      }, this));
      this.screens = {};
      this.enabled = [];
    }
    ScreenManager.prototype.add = function(name, screen, enable) {
      if (enable == null) {
        enable = false;
      }
      if (!isFunction(screen)) {
        return null;
      }
      screen = new screen(name, this.game);
      if (!screen instanceof Screen) {
        return false;
      }
      screen.bind('update', null, [this.game.loop.delta]);
      screen.bind('render', null, [this.game.loop.context]);
      this.screens[name] = screen;
      if (enable) {
        this.enable(name);
      }
      return this;
    };
    ScreenManager.prototype.toggle = function(disable, enable) {
      this.disable(disable);
      return this.enable(enable);
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
      this.screens[name].focus();
      this.enabled.push(name);
      return this;
    };
    ScreenManager.prototype.disable = function(name) {
      var i, screen, _i, _len;
      if (isArray(name)) {
        for (_i = 0, _len = name.length; _i < _len; _i++) {
          i = name[_i];
          this.disable(i);
        }
        return;
      }
      screen = this.screens[name];
      if (screen.persistent) {
        return false;
      }
      screen.tick = 0;
      screen.blur();
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
      var name, screen, _i, _len, _ref;
      _ref = this.enabled;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        screen = this.screens[name];
        if (this.focus === false && screen.persistent === false) {
          continue;
        }
        this.screens[name].update(this.game.Loop.tick);
        this.screens[name].tick += this.game.Loop.delta;
      }
    };
    ScreenManager.prototype.render = function() {
      var name, screen, _i, _len, _ref;
      _ref = this.enabled;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        screen = this.screens[name];
        if (this.focus === false && screen.persistent === false) {
          continue;
        }
        this.screens[name].render.call();
      }
    };
    return ScreenManager;
  })();
});