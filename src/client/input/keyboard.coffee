#
define ->
	{throttle} = _
	{Event} = Motion

	class Keyboard
		_setup = false
		_instance = null

		@instance: ->
			return if _instance then _instance else new @()

		# Maps event codes to key names.
		_KEYMAP =
			8:  'backspace'
			9:  'tab'
			13: 'return'
			#16: 'shift'
			#17: 'ctrl'
			#18: 'alt'
			20: 'caps'
			27: 'esc'
			32: 'space'
			37: 'left'
			38: 'up'
			39: 'right'
			40: 'down'
			#91: 'lsuper'
			#93: 'rsuper'
		# 0...10
		_KEYMAP[48 + i] = i for i in [0...10]
		# a...z
		_KEYMAP[65 + i] = String.fromCharCode 97 + i for i in [0...26]

		# Maps key names to event codes.
		_CODEMAP       = {}
		_CODEMAP[key] = code for code, key of _KEYMAP

		_onKeyDown = (event) ->
			return false if not (key = _KEYMAP[event.which])

			@_setKeyState key, event, true

			###@event.fire 'down', [key, {
				alt:   (@altKey   = event.altKey)
				ctrl:  (@ctrlKey  = event.ctrlKey)
				meta:  (@metaKey  = event.metaKey)
				shift: (@shiftKey = event.shiftKey)
				time:  event.timeStamp
				which: event.which
			}]###

		_onKeyUp = (event) ->
			return false if not (key = _KEYMAP[event.which])

			@_setKeyState key, event, false

			###@event.fire 'up', [key, {
				alt:   (@altKey   = event.altKey)
				ctrl:  (@ctrlKey  = event.ctrlKey)
				meta:  (@metaKey  = event.metaKey)
				shift: (@shiftKey = event.shiftKey)
				time:  event.timeStamp
				which: event.which
			}]###

		_setKeyState: (key, event, held) ->
			key = @keys[key]

			if not (key.held = held)
				key.alt   = false
				key.ctrl  = false
				key.meta  = false
				key.shift = false
			else
				key.alt   = event.altKey
				key.ctrl  = event.ctrlKey
				key.meta  = event.metaKey
				key.shift = event.shiftKey

			return

		key: (key)  -> @keys[key] or false
		life: (key) -> @keys[key].life
		down: (key) -> @keys[key].held is true
		up:   (key) -> @keys[key].held is false

		downFor: (key, duration) ->
			(key = @keys[key]) and key.held and key.life >= duration

		altKey:   false
		ctrlKey:  false
		metaKey:  false
		shiftKey: false

		update: (dt) ->
			for key, data of @keys
				if data.held is true
					data.life += dt
				else if data.life isnt 0
					data.life = 0

		constructor: ->
			return _instance if _instance?

			@event = new Event ['up', 'down'], binding: @

			@keys = {}
			for code, key of _KEYMAP
				@keys[key] = {
					alt:   false
					ctrl:  false
					meta:  false
					shift: false
					held:  false
					life:  0
				}

			jQuery =>
				$el = jQuery document
				$el.keyup   _onKeyUp.bind(@)
				$el.keydown _onKeyDown.bind(@)

				$el.bind 'contextmenu', (e) -> e.preventDefault() ; e.stopPropagation()

			_instance = @
