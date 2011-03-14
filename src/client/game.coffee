define [
	'class'
	'eventful'
	'stateful'
	'loop'
	'input'
	'canvas'
	'screenmanager'
	'physics/world'
], (Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World) ->
	class Game extends Class
		constructor: (options) ->
			options = Motion.ext {
				size: [1024, 768]
				delta: 1.0 / 60
			}, options
			
			super()

			@world      = new World [2000, 2000]
			@world.game = @

			if Motion.env is 'client'
				@Input    = new Input
				@Screen   = new MScreen @
				#@Graphics = new Graphics

			@Loop       = new Loop @
			@Loop.delta = options.delta
			
			@Event = new Eventful

			@canvas = new Canvas options.size
			@canvas.create()

			@Loop.context = @canvas.context
			@Input?.setup @canvas.$canvas
	
	Game