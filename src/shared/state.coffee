define ->
	{Class, Eventful} = Motion

	class State extends Class
		tick: 0

		active:     false
		loaded:     false
		persistent: false

		load:   null
		unload: null
		focus:  null
		blur:   null

		constructor: (name) ->
			super()

			@_name = name
			@event = new Eventful ['load', 'unload', 'focus', 'blur'], binding: @
			@game  = require('client/game').instance()

			@event.on 'focus', (-> @event.fire 'load'), once: true

			@event.on 'load',   -> @log 'loaded'   ; @loaded = true
			@event.on 'unload', -> @log 'unloaded' ; @loaded = false
			@event.on 'focus',  -> @log 'focused'  ; @active = true
			@event.on 'blur',   -> @log 'blurred'  ; @active = false

			if Function.isFunction @load
				@event.on 'load', @load
			
			if Function.isFunction @unload
				@event.on 'unload', @unload
			
			if Function.isFunction @focus
				@event.on 'focus', @focus

			if Function.isFunction @blur
				@event.on 'blur', @blur

			if Function.isFunction @input
				@input = @input.bind @, @game.keyboard, @game.mouse

			###
			@Event.on 'beforeIn', ->
				@screenLayer.fadeIn @fadeIn,
				=> @Event.fire 'afterIn'
			
			@Event.on 'beforeOut', ->
				@screenLayer.fadeOut @fadeOut,
				=> @Event.fire 'afterOut'
			###

			###@elements = {}
			@screenLayer = jQuery('<div />')
				.attr('id', @_name + 'Screen')
				.css('z-index', @zIndex)
				.addClass('mjsScreenLayer')
				.appendTo('body')###

		log: (log) ->
			console.log "[State:#{@_name}] #{log}"
		
		update: ->
		render: ->

		enable:  -> @game.state.enable  @_name
		disable: -> @game.state.disable @_name

		toggle: (name) -> @game.state.toggle @_name, name
