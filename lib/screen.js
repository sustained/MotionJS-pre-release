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
    Screen.prototype.tick = 0;
    zIndex = 0;
    Screen.prototype.loaded = false;
    Screen.prototype.persistent = false;
    Screen.prototype.blur = noop;
    Screen.prototype.focus = noop;
    function Screen(name, Game) {
      this.name = name;
      this.Game = Game;
      Screen.__super__.constructor.call(this);
      this.E = this.Event = new Eventful(['loaded', 'unloaded', 'enabled', 'disabled', 'beforeIn', 'afterIn', 'beforeOut', 'afterOut'], {
        bind: this
      });
      this.GUI = {};
      this.zIndex = ++zIndex;
      this.Event.on('loaded', function() {
        return this.loaded = true;
      });
      this.Event.on('unloaded', function() {
        return this.loaded = false;
      });
      /*
      			@Event.on 'beforeIn', ->
      				@screenLayer.fadeIn @fadeIn,
      				=> @Event.fire 'afterIn'

      			@Event.on 'beforeOut', ->
      				@screenLayer.fadeOut @fadeOut,
      				=> @Event.fire 'afterOut'

      			@elements = {}
      			@screenLayer = $ '<div />'
      				.attr 'id', @name + 'Screen'
      				.css 'z-index', @zIndex
      				.addClass 'motionScreenLayer'
      				.appendTo 'body'
      			*/
    }
    Screen.prototype.update = function(Game, tick, delta) {};
    Screen.prototype.render = function(Game, alpha, context) {};
    Screen.prototype.load = noop;
    Screen.prototype.unload = noop;
    return Screen;
  })();
  return Screen;
});