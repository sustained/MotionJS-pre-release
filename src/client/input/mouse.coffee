define [
	'eventful'
], (Eventful) ->
	class Mouse
		_setup     = false
		_singleton = null
		
		_MAP = 1: 'left', 2: 'middle', 3: 'right'
		
		_onMouseDown = (e) ->
			button = _MAP[e.which]
			
			if @mouse[button] is off
				@mouse[button] = on
				@event.fire 'down', [button, e]
		
		_onMouseUp = (e) ->
			button = _MAP[e.which]
			
			if @mouse[button] is on
				@mouse[button] = off
				@event.fire '_up', [but, e]
		
		_onMouseMove = (e) ->
			#if e.timeStamp - @lastUpdate > 100
			#@lastUpdate = Date.now()
			@position.set e.pageX, e.pageY
		
		
		position: null
		
		left:   false
		right:  false
		middle: false
		
		lastUpdate:   0
		waitInterval: 1.0 / 60
		
		isMouseDown: (button) -> @mouse[button] is on
		isMouseUp:   (button) -> @mouse[button] is off
		
		constructor: ->
			return _singleton if _singleton?
			
			@event    = new Eventful ['down', 'up'], binding: @
			@position = new Math.Vector
			
			@event.on 'up', (button) ->
				@left   = button is 'left'
				@right  = button is 'right'
				@middle = button is 'middle'
				
			_singleton = @
		
		setup: ($el) ->
			$el = $el ? $(document)
			$el.mouseup   _onMouseUp  .bind @
			$el.mousedown _onMouseDown.bind @
			$el.mousemove _onMouseMove.bind @