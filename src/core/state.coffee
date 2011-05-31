define ->
	{Class, Eventful} = Motion

	class State extends Class
		tick: 0

		loaded:     false
		persistent: false

		load:   null
		unload: null
		focus:  null
		blur:   null

		constructor: (name, @game) ->
			super()

			@_name = name
			@event = new Eventful ['load', 'unload', 'focus', 'blur'], binding: @
			@state = @game.state

			@event.on 'load', ->
				if Function.isFunction @load
					@log 'loading'
					@loaded = true
					@load() 
				else
					@log 'nothing to load'

			@event.on 'unload', ->
				@log 'unloading'
				@loaded = false
				@unload() if Function.isFunction @unload

			@event.on 'focus', (->
				@event.fire 'load'
			), once: true

			@event.on 'focus', ->
				@log 'focusing'
				@focus() if Function.isFunction @focus

			#console.log @event.events.focus

			@event.on 'blur', ->
				@log 'blurring'
				@blur() if Function.isFunction @blur

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
			console.log "State #{@_name}: #{log}"
		
		update: ->
		render: ->

		enable:  -> @state.enable  @_name
		disable: -> @state.disable @_name

		toggle: (name) -> @state.toggle @_name, name
