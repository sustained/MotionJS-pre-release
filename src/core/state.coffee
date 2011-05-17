define ->
	{Class, Eventful} = Motion

	class State extends Class
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

		constructor: (name, @game) ->
			super()

			@_name = name

			@event = new Eventful [
				'load',   'unload'
				'focus',  'blur'
				'enable', 'disable'
				#'beforeIn',  'afterIn'
				#'beforeOut', 'afterOut'
			], binding: @

			@state = @game.state
			@zIndex = ++zIndex

			@event.on 'load', ->
				console.log "Loading state #{@_name}"
				@loaded = true
				@load() if @load isnt null

			@event.on 'unload', ->
				console.log "Unloading state #{@_name}"
				@loaded = false
				@unload() if @unload isnt null

			@event.on 'focus', ->
				console.log "Focusing state #{@_name}"
				if @loaded is false then @event.fire 'load'
				@focus() if @focus isnt null

			@event.on 'blur', ->
				console.log "Blurring state #{@_name}"
				@blur() if @blur isnt null

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

		update: ->
		render: ->

		enable:  -> @state.enable  @_name
		disable: -> @state.disable @_name

		toggle: (name) -> @state.toggle @_name, name
