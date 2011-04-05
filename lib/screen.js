var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['class', 'eventful'], function(Class, Eventful) {
  var Screen;
  Screen = (function() {
    var zIndex;
    __extends(Screen, Class);
    zIndex = 0;
    Screen.prototype.tick = 0;
    Screen.prototype.loaded = false;
    Screen.prototype.persistent = false;
    Screen.prototype.transitionIn = null;
    Screen.prototype.transitionOut = null;
    Screen.prototype.blur = function() {
      return null;
    };
    Screen.prototype.focus = function() {
      return null;
    };
    function Screen(name, game) {
      this.name = name;
      this.game = game;
      Screen.__super__.constructor.call(this);
      this.event = new Eventful(['loaded', 'unloaded', 'enabled', 'disabled', 'beforeIn', 'afterIn', 'beforeOut', 'afterOut'], {
        bind: this
      });
      this.GUI = {};
      this.zIndex = ++zIndex;
      this.event.on('loaded', function() {
        return this.loaded = true;
      });
      this.event.on('unloaded', function() {
        return this.loaded = false;
      });
      /*
      			@Event.on 'beforeIn', ->
      				@screenLayer.fadeIn @fadeIn,
      				=> @Event.fire 'afterIn'

      			@Event.on 'beforeOut', ->
      				@screenLayer.fadeOut @fadeOut,
      				=> @Event.fire 'afterOut'
      			*/
      this.screenLayer = $('<div />').attr('id', this.name + 'Screen').css('z-index', this.zIndex).addClass('mjsScreenLayer');
    }
    Screen.prototype.update = function(Game, tick, delta) {};
    Screen.prototype.render = function(Game, alpha, context) {};
    Screen.prototype.load = function() {
      return null;
    };
    Screen.prototype.unload = function() {
      return null;
    };
    return Screen;
  })();
  return Screen;
});