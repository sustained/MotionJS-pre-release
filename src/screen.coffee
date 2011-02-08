define [
	'motion',
	'eventful'
], (Motion, Eventful) ->
	class Screen extends Motion.Class
		tick: 0
		zIndex = 0
		
		loaded:     false
		persistent: false
		
		#fadeIn:  1000
		#fadeOut: 1000
		
		constructor: (@name, @Game) ->
			super()
			
			@E = @Event = new Eventful [
				'loaded',    'unloaded'
				'enabled',   'disabled'
				'beforeIn',  'afterIn'
				'beforeOut', 'afterOut'
			], bind: @
			@GUI    = {}
			@zIndex = ++zIndex
			
			@Event.on 'loaded', -> @loaded = true
			
			@Event.on 'unloaded', -> @loaded = false
			
			###
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
			###
		
		update: (Game, tick, delta) ->
			
		
		render: (Game, alpha, context) ->
			
		
		load:   noop
		unload: noop
	
	Screen