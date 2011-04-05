define [
	'eventful'
], (Eventful) ->
	class Keyboard
		_setup     = false
		_singleton = null
		
		# Maps event codes to key names.
		_KEYMAP =
			8:  'backspace'
			9:  'tab'
			13: 'return'
			16: 'shift'
			17: 'ctrl'
			18: 'alt'
			20: 'caps'
			27: 'esc'
			32: 'space'
			37: 'left'
			38: 'up'
			39: 'right'
			40: 'down'
			91: 'lsuper'
			93: 'rsuper'
		# 0...10
		_KEYMAP[48 + i] = i for i in [0...10]
		# a...z
		_KEYMAP[65 + i] = String.fromCharCode 97 + i for i in [0...26]
		console.log _KEYMAP
		
		###
			48:  0
			49:  1
			50:  2
			51:  3
			52:  4
			53:  5
			54:  6
			55:  7
			56:  8
			57:  9
			65: 'a'
			66: 'b'
			67: 'c'
			68: 'd'
			69: 'e'
			70: 'f'
			71: 'g'
			72: 'h'
			73: 'i'
			74: 'j'
			75: 'k'
			76: 'l'
			77: 'm'
			78: 'n'
			79: 'o'
			80: 'p'
			81: 'q'
			82: 'r'
			83: 's'
			84: 't'
			85: 'u'
			86: 'v'
			87: 'w'
			88: 'x'
			89: 'y'
			90: 'z'
		###
		
		# Maps key names to event codes.
		_CODEMAP       = {}
		_CODEMAP[key] = code for code, key of _KEYMAP
		
		_onKeyDown = (event) ->
			return false if (key = _KEYMAP[event.which]) is undefined or @keys[key] is on
			
			@keys[key] = on
			@event.fire 'down', [key, {
				alt:   event.altKey
				ctrl:  event.ctrlKey
				meta:  event.metaKey
				shift: event.shiftKey
				time:  event.timeStamp
				which: event.which
			}]
		
		_onKeyUp = (event) ->
			return false if (key = _KEYMAP[event.which]) is undefined or @keys[key] is off
			
			@keys[key] = off
			@event.fire 'up', [key, {
				alt:   event.altKey
				ctrl:  event.ctrlKey
				shift: event.shiftKey
				meta:  event.metaKey
				time:  event.timeStamp
				which: event.which
			}]
		
		isKeyDown: (key) -> @keys[key] is on
		isKeyUp:   (key) -> @keys[key] is off
		
		altKey:   false
		ctrlKey:  false
		metaKey:  false
		shiftKey: false
		
		constructor: ->
			return _singleton if _singleton?
			
			@event = new Eventful ['up', 'down'], binding: @
			
			@keys       = {}
			@keys[key] = off for code, key of _KEYMAP
			
			_singleton = @
		
		setup: ($el) ->
			return if _setup
			
			$el = $el ? $(document)
			$el.keyup   _onKeyUp  .bind @
			$el.keydown _onKeyDown.bind @
			
			true
