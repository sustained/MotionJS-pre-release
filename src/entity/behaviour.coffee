#
class Behaviour
	_update: noop
	_render: noop

	_lastUpdate: 0
	_lastRender: 0

	active: true
	entity: null

	constructor: (@Game) ->
		throw 'Need @Game' if not Game instanceof Motion.Game

		Class.get @, 'update', -> @_update
		Class.set @, 'update', (update) ->
			@_update = if isFunction update then update.bind @, @Game else noop

		Class.get @, 'render', -> @_render
		Class.set @, 'render', (render) ->
			@_render = if isFunction render then render.bind @, @Game else noop

	doUpdate: (Game) ->
		return if not @active
		@_update Game.Loop.tick, Game.Loop.delta
		@_lastUpdate = Game.Loop.tick.round()

	doRender: (Game) ->
		return if not @active
		@_render Game.Loop.alpha, Game.Loop.context
		@_lastRender = Game.Loop.tick.round()

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

