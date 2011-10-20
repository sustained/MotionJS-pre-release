#
define [
	'utilities/eventful'
], (Event) ->
	{isFunction} = _

	class State
		@STATE:
			default:   0
			loading:   1
			loaded:    2
			unloading: 3
			unloaded:  4

		tick: 0

		_active:     false
		_loaded:     false
		_persistent: false

		load:   null
		unload: null
		focus:  null
		blur:   null

		loaded: false

		constructor: (@name, @manager) ->
			@event = new Event ['load', 'unload', 'focus', 'blur'], binding: @

			@event.on 'focus', (-> @event.fire 'load'), once: true

			@event.on 'load',   -> @log 'loaded'   #; @_loaded = true
			@event.on 'unload', -> @log 'unloaded' #; @_loaded = false

			@event.on 'focus',  -> @log 'focused'  ; @_active = true
			@event.on 'blur',   -> @log 'blurred'  ; @_active = false

			@event.on('load',   @load)   if isFunction @load
			@event.on('unload', @unload) if isFunction @unload

			@event.on('focus', @focus) if isFunction @focus
			@event.on('blur', @blur)   if isFunction @blur

			@_state = State.STATE.default

		log: (log) ->
			console.log "#{@manager.loop.tick.toFixed 2} [State:#{@name}/#{@constructor.name}] #{log}"

		enter:  ->
		leave:  ->
		update: ->

		enable:  -> @manager.enable  @name
		disable: -> @manager.disable @name

		toggle: (name) -> @manager.toggle @name, name
