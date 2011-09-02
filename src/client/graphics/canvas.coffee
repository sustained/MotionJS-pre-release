define ['utilities/object'], (ObjUtils) ->
	{merge} = ObjUtils
	{Vector} = Math
	{isString} = _

	class Canvas
		_canvases = {}
		_bufferId = 0

		_defaultOptions =
			show: true
			size: [1024, 768]

		@_create: (name, canvas) ->
			return _canvases[name] = canvas
		@log: -> _canvases
		@buffer: (image) ->
			if image.isLoaded()
				name = "motionBuffer#{_bufferId++}"
				console.log buffer = @_create name, new Canvas name, {
					size: [image.width, image.height]}
				buffer.create()
				if buffer.created
					buffer.context.drawImage image.domOb, 0, 0
				buffer

		@isCanvas: (name) ->
			_canvases[name]?

		@get: (name) ->
			return _canvases[name] if @isCanvas name

		@DEFAULT_DIMENSIONS: [1024, 768]

		_id = 0

		name: null
		size: null
		show: null

		#fill:   null
		#width:  null
		#stroke: null

		canvas:  null # DOM Object
		$canvas: null # jQuery Object
		context: null

		created: false
		queued: false

		getImageData: ->
			@context.getImageData 0, 0, @size[0], @size[1]

		create: ->
			if not Motion.READY
				return if @queued
				@queued = true
				return jQuery => @create()

			@$canvas = jQuery('<canvas>')
				.attr(id: @name, width: @size[0], height: @size[1])
				.css(
					top:  if @show then '0px' else '-10000px'
					left: if @show then '0px' else '-10000px'
					width:  @size[0] + 'px'
					height: @size[1] + 'px'
					zIndex: @id
					position: 'absolute'
					backgroundColor: 'transparent'
				)
				.appendTo('body')

			@canvas  = @$canvas.get 0
			@context = @canvas.getContext '2d'
			@created = true
			console.log 'canvas created'

		constructor: (name = 'default', options = {}) ->
			return Canvas.get(name) if Canvas.isCanvas name

			console.log options
			console.log options = _.defaults _defaultOptions, options

			@id = ++_id
			@name = "motionCanvas#{@id}"
			{@size, @show} = options

			Canvas._create name, @

		###draw: (style = {}) ->
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
		@RECT_MODE: 'center'
		@DEFAULT_FONT: 'Deja Vu Sans Mono'

		circle: (position, radius, style)->
			position = position.clone().round()

			if Canvas.CIRC_MODE is 'corner'
				position.i -= radius
				position.j -= radius

			@context.beginPath()
			@context.arc position.i, position.j, radius, 0, Math.TAU, false
			@context.closePath()

			@draw style

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

			@draw style###

		setSize: (width, height) ->
			return false if not @created
			@$canvas.attr width: width, height: height
			@$canvas.css width: width + 'px', height: height + 'px'

		validContext: ->
			@context instanceof CanvasRenderingContext2D

		clear: ->
			@context.clearRect 0, 0, @size[0], @size[1]

	Canvas
