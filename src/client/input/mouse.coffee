define ->
	{Vector} = Math
	{Event} = Motion

	class Mouse
		_instance = null

		@instance: ->
			return if _instance then _instance else new @()

		_MAP =
			1: 'left'
			2: 'middle'
			3: 'right'

		_onMouseDown = (e) ->
			button = _MAP[e.which]

			if @[button] is false
				@[button] = true
				@event.fire 'down', [button, e]

		_onMouseUp = (e) ->
			button = _MAP[e.which]

			if @[button] is true
				@[button] = false
				@event.fire 'up', [button, e]

		_onMouseMove = (e) ->
			#if e.timeStamp - @lastUpdate > 100
			#@lastUpdate = Date.now()
			@position.set e.pageX, e.pageY

		position: null

		left:   false
		middle: false
		right:  false

		waitInterval: 1.0 / 60

		down: (button) -> @[button] is true
		up:   (button) -> @[button] is false

		constructor: ->
			return _instance if _instance?

			@event    = new Event ['down', 'up'], binding: @
			@position = new Vector

			#@event.on 'up', (button) ->
			#	@left   = button is 'left'
			#	@right  = button is 'right'
			#	@middle = button is 'middle'

			jQuery =>
				$el = jQuery document
				$el.mouseup   _onMouseUp  .bind @
				$el.mousedown _onMouseDown.bind @
				$el.mousemove _onMouseMove.bind @

			_instance = @

		inCamera: (camera) ->
			Vector.add camera.position, @position
