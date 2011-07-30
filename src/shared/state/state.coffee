define [
	'shared/utilities/eventful'
], (Event) ->
	{isFunction} = _

	class State
		tick: 0

		active:     false
		loaded:     false
		persistent: false

		load:   null
		unload: null
		focus:  null
		blur:   null

		constructor: (@name, @manager) ->
			@event = new Event ['load', 'unload', 'focus', 'blur'], binding: @

			@event.on 'focus', (-> @event.fire 'load'), once: true

			@event.on 'load',   -> @log 'loaded'   ; @loaded = true
			@event.on 'unload', -> @log 'unloaded' ; @loaded = false
			@event.on 'focus',  -> @log 'focused'  ; @active = true
			@event.on 'blur',   -> @log 'blurred'  ; @active = false

			###if isFunction @load
				@event.on 'load', @load

			if isFunction @unload
				@event.on 'unload', @unload

			if isFunction @focus
				@event.on 'focus', @focus

			if isFunction @blur
				@event.on 'blur', @blur

			@Event.on 'beforeIn', ->
				@screenLayer.fadeIn @fadeIn,
				=> @Event.fire 'afterIn'

			@Event.on 'beforeOut', ->
				@screenLayer.fadeOut @fadeOut,
				=> @Event.fire 'afterOut'

			@elements = {}
			@screenLayer = jQuery('<div />')
				.attr('id', @_name + 'Screen')
				.css('z-index', @zIndex)
				.addClass('mjsScreenLayer')
				.appendTo('body')###

		log: (log) ->
			console.log "#{@manager.loop.tick.toFixed 2} [State:#{@name}/#{@constructor.name}] #{log}"

		update: ->
		render: ->

		enable:  -> @manager.enable  @name
		disable: -> @manager.disable @name

		toggle: (name) -> @manager.toggle @name, name
