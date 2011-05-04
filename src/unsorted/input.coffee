input = (Vector, Eventful) ->
	class Input
		@CHARMAP:
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
			91: 'lsuper'
			93: 'rsuper'
	
		@CODEMAP: {}
	
		@MOUSEMAP:
			1: 'left'
			2: 'middle'
			3: 'right'
	
		@codeToChar: (code) ->
			@CHARMAP[code] if code of @CHARMAP
	
		@charToCode: (char) ->
			@CODEMAP[char] if char of @CODEMAP
		
		_onKeyDown: (e) ->
			chr = Input.codeToChar e.which
			return false if chr is false
		
			if @keyboard[chr] is off
				@keyboard[chr] = on
				@altKey        = e.altKey
				@metaKey       = e.metaKey
				@shiftKey      = e.shiftKey
				@Event.fire 'key_down', [chr, e]
	
		_onKeyUp: (e) ->
			chr = Input.codeToChar e.which
			return false if chr is false
		
			if @keyboard[chr] is on
				@keyboard[chr] = off
				@altKey        = e.altKey
				@metaKey       = e.metaKey
				@shiftKey      = e.shiftKey
				@Event.fire 'key_up', [chr, e]
	
		_onMouseDown: (e) ->
			but = Input.MOUSEMAP[e.which]
		
			if @mouse[but] is off
				@mouse[but] = on
				@Event.fire 'mouse_down', [but, e]
	
		_onMouseUp: (e) ->
			but = Input.MOUSEMAP[e.which]
		
			if @mouse[but] is on
				@mouse[but] = off
				@Event.fire 'mouse_up', [but, e]
	
		_onMouseMove: (e) ->
			if e.timeStamp - @lastMUpdate > 25
				@lastMUpdate = e.timeStamp
				@mouse.position.page.set e.pageX, e.pageY
				#@Event.fire 'mouse_move', [x, y]
	
		isMouseDown: (button) -> @mouse[button] is on
		isMouseUp:   (button) -> @mouse[button] is off
	
		isKeyDown: (key) -> @keyboard[key] is on
		isKeyUp:   (key) -> @keyboard[key] is off
		
		altKey:   false
		metaKey:  false
		shiftKey: false
		
		update: (camera) ->
			@mouse.position.game = Vector.add camera.position, @mouse.position.page
		
		constructor: (@Game) ->
			@Event = new Eventful 'key_up', 'key_down', 'mouse_up', 'mouse_down', 'mouse_move'
			
			@mouse = 
				left:   off
				right:  off
				scroll: null
				middle: false
				position:
					page: new Vector
					game: new Vector
			
			@lastMUpdate = 0
			@lastKUpdate = 0
			
			@keyboard  = {}
			@keyEvents = {}
		
			@keyboard[char] = off for code, char of Input.CHARMAP
			
			#doc = $(document)
			#doc.bind 'oncontextmenu', (e) -> e.preventDefault()
			#doc.keyup     @_onKeyUp.bind     @
			#doc.keydown   @_onKeyDown.bind   @
			#doc.mouseup   @_onMouseUp.bind   @
			#doc.mousedown @_onMouseDown.bind @
			#doc.mousemove @_onMouseMove.bind @
		
		setup: ($el) ->
			$doc = jQuery document
			
			$doc.keyup   @_onKeyUp.bind   @
			$doc.keydown @_onKeyDown.bind @
			
			$el.mouseup   @_onMouseUp.bind   @
			$el.mousedown @_onMouseDown.bind @
			$el.mousemove @_onMouseMove.bind @
		
	Input.CODEMAP[char] = code for code, char of Input.CHARMAP
	
	Input

define [
	'math/vector'
	'utilities/eventful'
], input