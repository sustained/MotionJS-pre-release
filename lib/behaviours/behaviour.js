define(function() {
  var Behaviour;
  Behaviour = (function() {
    Behaviour.prototype.update = function() {
      return null;
    };
    Behaviour.prototype.render = function() {
      return null;
    };
    Behaviour.prototype.active = true;
    Behaviour.prototype.parent = null;
    Behaviour.prototype.listener = null;
    function Behaviour(parent, listener) {
      this.parent = parent;
      this.listener = listener != null ? listener : this.parent;
      this.game = require('client/game');
      /*
      			Class.get @, 'update', -> @_update
      			Class.set @, 'update', (update) ->
      				@_update = if isFunction update then update.bind @, @Game else noop

      			Class.get @, 'render', -> @_render
      			Class.set @, 'render', (render) ->
      				@_render = if isFunction render then render.bind @, @Game else noop
      			*/
    }
    /*
    		doUpdate: (Game) ->
    			return if not @active
    			@_update Game.Loop.tick, Game.Loop.delta
    			@_lastUpdate = Game.Loop.tick.round()

    		doRender: (Game) ->
    			return if not @active
    			@_render Game.Loop.alpha, Game.Loop.context
    			@_lastRender = Game.Loop.tick.round()
    		*/
    return Behaviour;
  })();
  return Behaviour;
});
/*
class FallingBlockBehaviour extends Behaviour
	constructor: ->
		@lastUpdate = 0

	update: (tick, delta) ->
		if tick.round() - @lastUpdate > 1
			@lastUpdate = tick.round()


class AnimationBehaviour extends Behaviour
	constructor: (@entity, @frameDuration, @animation, @listener) ->
		@currentTime  = 0
		@currentFrame = 0

	update: (tick, delta) ->
		@currentTime = tick

		if @currentTime >= @frameDuration
			@currentTime -= @frameDuration
			@currentFrame++

			if @currentFrame < @animation.length
				@parent.setImage @animation[@currentFrame]
			else
				null

	reset: ->
		@active = true
		@currentFrame = 0

class MotionBehaviour extends Behaviour
	constructor: (@parent) ->
		@active = false

		@velocity     = new Vector
		@maxVelocity  = new Vector
		@acceleration = new Vector

	update: ->
*/