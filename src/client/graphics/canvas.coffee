define ->
	{Vector} = Math

	class Canvas
		@DEFAULT_DIMENSIONS: [1024, 768]

		_canvasId = 0

		name: null
		size: Canvas.DefaultDimensions
		show: true

		fill:   'white'
		width:  1.0
		stroke: 'white'

		canvas:  null # DOM Object
		$canvas: null # jQuery Object
		context: null

		created: false

		create: ->
			#jQuery =>
			@$canvas = jQuery('<canvas>').attr id: @name, width: @size[0], height: @size[1]
			@$canvas.css
					top:  if @show then '0px' else '-10000px'
					left: if @show then '0px' else '-10000px'
					width:  @size[0] + 'px'
					height: @size[1] + 'px'
					zIndex: @id
					position: 'absolute'
					backgroundColor: '#000000'
			@$canvas.appendTo 'body'

			@canvas  = @$canvas.get 0
			@context = @canvas.getContext '2d'
			@created = true
			console.log 'canvas created'

		constructor: (@size = Canvas.DEFAULT_DIMENSIONS) ->
			@id   = ++_canvasId
			@name = "motionCanvas#{@id}"

			###
			resizeMap = {
				 800:  600
				1024:  768
				1280: 1024
				1680: 1050
			}

			lastResize = 0

			$w.resize (e) =>
				return if Date.now() - lastResize < 4000
				w = $w.width()
				h = $w.height()
				for size in DIMENSIONS
					if w is size[0] and h is size[1]
						@setSize w, h
						console.log "#{new Date} resizing canvas to supported resolution #{w}x#{h}"
					else
						ww = Math.nearest w, 800, 1024, 1280, 1680
						continue if not ww of resizeMap

						hh = resizeMap[ww]

						return if ww is w or hh is h
						@setSize ww, hh
						console.log "#{new Date} resizing canvas to nearest supported resolution #{ww}x#{hh}"
						break
				lastResize = Date.now()
				false
			###

		draw: (style = {}) ->
			if style.fill
				@context.fillStyle = style.fill
				@context.fill()

			if style.stroke
				@context.lineWidth   = style.width or 1.0
				@context.strokeStyle = style.stroke
				@context.stroke()

		lineV: (position, direction, style) ->
			@line position, direction, style

		lineA: (position, direction, style) ->
			@line new Vector(position), new Vector(direction), style

		line: (position, direction, style) ->
			position = position.clone().round()

			@context.beginPath()
			@context.moveTo position.i,  position.j
			@context.lineTo direction.i, direction.j
			@context.closePath()

			@draw style

		point: (position, style) ->
			@rectangle position, [1, 1], style

		@CIRC_MODE: 'center'

		circle: (position, radius, style)->
			position = position.clone().round()

			if Canvas.CIRC_MODE is 'corner'
				position.i -= radius
				position.j -= radius

			@context.beginPath()
			@context.arc position.i, position.j, radius, 0, Math.TAU, false
			@context.closePath()

			@draw style

		@RECT_MODE: 'center'

		@DEFAULT_FONT: 'Deja Vu Sans Mono'

		text: (position, text, style = {}) ->
			position = position.clone().round()

			@context.font         = style.font or Canvas.DEFAULT_FONT
			@context.textAlign    = style.align if style.align
			@context.textBaseline = style.base  if style.base

			if style.fill
				@context.fillStyle = style.fill
				@context.fillText text, position.i, position.j

			if style.stroke
				@context.strokeStyle = stroke.style
				@context.strokeText text, position.i, position.j

		rectangle: (position, dimensions, style = {}) ->
			position = position.clone().round()

			if style.mode is 'center'
				position.i -= dimensions[0] / 2
				position.j -= dimensions[1] / 2

			if style.fill
				@context.fillStyle = style.fill
				@context.fillRect position.i.round(), position.j.round(), dimensions[0], dimensions[1]

			if style.stroke
				@context.lineWidth   = style.width or 1.0
				@context.strokeStyle = style.stroke
				@context.strokeRect position.i.round(), position.j.round(), dimensions[0], dimensions[1]

		polygon: (vertices, style) ->
			@context.beginPath()
			@context.moveTo vertices[0].i.round(), vertices[0].j.round()
			@context.lineTo vertex.i.round(), vertex.j.round() for vertex in vertices
			@context.lineTo vertices[0].i.round(), vertices[0].j.round()
			@context.closePath()

			@draw style

		setSize: (width, height) ->
			return false if not @created
			@$canvas.attr width: width, height: height
			@$canvas.css width: width + 'px', height: height + 'px'

		validContext: ->
			@context instanceof CanvasRenderingContext2D

		clear: ->
			@context.clearRect 0, 0, @size[0], @size[1]

	Canvas
