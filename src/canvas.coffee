canvas = (Motion) ->
	class Canvas
		DIMENSIONS = [
			[800,   600]
			[1024,  768]
			[1280, 1024]
			[1680, 1050]
		]
	
		@DefaultDimensions: DIMENSIONS[1]
	
		_canvasId = -1
	
		name: null
		size: Canvas.DefaultDimensions
		show: true
	
		canvas:  null # DOM Object
		$canvas: null # jQuery Object
		context: null
	
		created: false
	
		constructor: ->
			@id   = ++_canvasId
			@name = "motionCanvas#{@id}"
			
			$w = $(window)
			
			resizeMap = {
				 800:  600
				1024:  768
				1280: 1024
				1680: 1050
			}
			
			lastResize = 0
			
			###
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
		
	
		create: ->
			return null if @created
		
			@$canvas = $('<canvas>').attr id: name, width: @size[0], height: @size[1]
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
	
		setSize: (width, height) ->
			return false if not @created
			@$canvas.attr width: width, height: height
			@$canvas.css width: width + 'px', height: height + 'px'
	
		validContext: ->
			@context instanceof CanvasRenderingContext2D
	
		clear: ->
			@context.clearRect 0, 0, @size[0], @size[1] if @validContext()
	
		randomPath: (n, stroke = 'red') ->
			@context.beginPath()
			@context.moveTo Math.random() * 1000, Math.random * 1000
			n.times =>
				@context.lineTo Math.random() * 1000, Math.random() * 1000
				return
			@context.closePath()
		
			@context.strokeStyle = stroke
			@context.stroke()

define ['motion'], canvas