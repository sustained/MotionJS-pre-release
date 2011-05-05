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
		
		load:   null
		unload: null
		focus:  null
		blur:   null
		
		constructor: (@name, @game) ->
			super()
			
			@event = new Eventful [
				'load',   'unload'
				'focus',  'blur'
				'enable', 'disable'
				#'beforeIn',  'afterIn'
				#'beforeOut', 'afterOut'
			], binding: @
			
			@screen = @game.screen
			@zIndex = ++zIndex
			
			@event.on 'load', ->
				@loaded = true
				@load() if @load
			
			@event.on 'unload', ->
				@loaded = false
				@unload() if @unload
			
			@event.on 'focus', ->
				if @loaded is false then @event.fire 'load'
				@focus() if @focus isnt null
			
			@event.on 'blur', ->
				@blur() if @blur isnt null
			
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
		
		update: (Game, tick, delta) ->
			
		
		render: (Game, alpha, context) ->
			
		
		enable:  -> @screen.enable @name
		disable: -> @screen.disable @name
		
		toggle: (name) -> @screen.toggle @name, name
