var state;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
state = function(Motion, Class, Eventful) {
  /*
  		Game State

  		...
  	*/  var DefaultState, State;
  State = (function() {
    __extends(State, Class);
    /*
    			Should this state run forever?
    		*/
    State.prototype.continuous = false;
    /*
    			The unix time of when the state was last enabled.
    		*/
    State.prototype.enableTime = 0;
    /*
    			The unix time of when the state was last disabled.
    		*/
    State.prototype.disableTime = 0;
    State.prototype.name = null;
    function State(Game) {
      State.__super__.constructor.call(this);
      this.Game = Game;
      this.Event = new Eventful('enable', 'disable', 'load', 'unload', 'delete', {
        binding: this
      });
      this.Event.on('load', function() {
        this.Game.Assets.createGroup("" + this);
        if (this.respondTo('before')) {
          return this.before();
        }
      });
      this.Event.on('unload', function() {
        this.Game.Assets.removeGroup("" + this);
        if (this.respondTo('after')) {
          return this.after();
        }
      });
    }
    /*

    		*/
    State.prototype.update = function(Game, tick, delta) {};
    /*

    		*/
    State.prototype.render = function(Game, alpha, context) {};
    /*

    		*/
    State.prototype.before = function() {};
    /*

    		*/
    State.prototype.after = function() {};
    State.prototype.loadView = function(view) {
      var group;
      group = this.Game.Assets.getGroup();
      this.Game.Assets.setGroup(this);
      this.Game.Assets.load({
        file: 'views/'
      });
      return this.Game.Assets.setGroup(group);
    };
    State.prototype.loadModel = function() {};
    return State;
  })();
  DefaultState = (function() {
    __extends(DefaultState, State);
    function DefaultState(Game) {
      DefaultState.__super__.constructor.call(this, Game);
    }
    DefaultState.prototype.before = function() {
      return this.Game.Assets.load;
    };
    DefaultState.prototype.after = function() {
      return this.Game.Assets.unload(this);
    };
    return DefaultState;
  })();
  return State;
};
define(['motion', 'class', 'eventful'], state);