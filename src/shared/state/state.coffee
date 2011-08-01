define [
	'shared/utilities/eventful'
], (Event) ->
	{isFunction} = _

	class State
		tick: 0

		_active:     false
		_loaded:     false
		_persistent: false

		load:   null
		unload: null
		focus:  null
		blur:   null

		constructor: (@name, @manager) ->
			@event = new Event ['load', 'unload', 'focus', 'blur'], binding: @

			@event.on 'focus', (-> @event.fire 'load'), once: true

			@event.on 'load',   -> @log 'loaded'   ; @_loaded = true
			@event.on 'unload', -> @log 'unloaded' ; @_loaded = false

			@event.on 'focus',  -> @log 'focused'  ; @_active = true
			@event.on 'blur',   -> @log 'blurred'  ; @_active = false

			@event.on('load',   @load)   if isFunction @load
			@event.on('unload', @unload) if isFunction @unload

			@event.on('focus', @focus) if isFunction @focus
			@event.on('blur', @blur)   if isFunction @blur

			###@event.on 'beforeIn', ->
				@screenLayer.fadeIn @fadeIn,
				=> @event.fire 'afterIn'

			@event.on 'beforeOut', ->
				@screenLayer.fadeOut @fadeOut,
				=> @event.fire 'afterOut'

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
