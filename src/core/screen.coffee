define ->
	{Class, Eventful} = Motion
	
	class Screen extends Class
		zIndex = 0
		
		tick: 0
		
		loaded:     false
		persistent: false
		
		#fadeIn:  1000
		#fadeOut: 1000
		
		transitionIn:  null
		transitionOut: null
		
		blur:  -> null
		focus: -> null
		
		constructor: (@name, @game) ->
			super()
			
			@event = new Eventful [
				'loaded',    'unloaded'
				'enabled',   'disabled'
				'beforeIn',  'afterIn'
				'beforeOut', 'afterOut'
			], bind: @
			
			@screen = @game.screen
			@zIndex = ++zIndex
			
			@event.on 'loaded',   -> @loaded = true
			@event.on 'unloaded', -> @loaded = false
			
			###
			@Event.on 'beforeIn', ->
				@screenLayer.fadeIn @fadeIn,
				=> @Event.fire 'afterIn'
			
			@Event.on 'beforeOut', ->
				@screenLayer.fadeOut @fadeOut,
				=> @Event.fire 'afterOut'
			###
			
			#@elements = {}
			@screenLayer = jQuery('<div />')
				.attr('id', @name + 'Screen')
				.css('z-index', @zIndex)
				.addClass('mjsScreenLayer')
				#.appendTo('body')
		
		image: (image, options = {}) ->
			
		
		audio: (audio, options = {}) ->
			
		
		video: (video, options = {}) ->
			
		
		update: (Game, tick, delta) ->
			
		
		render: (Game, alpha, context) ->
			
		
		enable:  -> @screen.enable @name
		disable: -> @screen.disable @name
		
		load:   -> null
		unload: -> null
