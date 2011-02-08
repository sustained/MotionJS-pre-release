define [
	'motion'
	'eventful'
	'stateful'
	'loop'
	'input'
	'screenmanager'
	'screen'
	'canvas'
	'colour'
], (Motion, Eventful, Stateful, Loop, Input, MScreen, Screen, Canvas, Colour) ->
	Motion = extend Motion, {
		Eventful
		Stateful
		Loop
		Input
		MScreen
		Screen
		Canvas
		Colour
	}
	
	class Game extends Motion.Class
		constructor: ->
			super()
			
			if Motion.env is 'client'
				@Input  = new Input
				@Screen = new MScreen @
			
			@Loop = new Loop @
			@E = @Event = new Eventful
	
	Game