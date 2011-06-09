###define [
	'motion',
	'../math/vector'
], (Motion, Vector) ->
	class Rectangle
		area:   0
		width:  0
		height: 0
		
		constructor: (width, height) ->
			@position = new Vector
			@define width, height
		
		define: (@width = 0, @height = 0) ->
			@area = @width * @height
			
			@
		
		draw: (pos, ctx) ->
			ctx.translate pos.i, pos.j
			
			ctx.beginPath()
			ctx.moveTo      0,       0
			ctx.lineTo @width,       0
			ctx.lineTo @width, @height
			ctx.lineTo      0, @height
			ctx.lineTo      0,       0
			ctx.closePath()
			
			ctx.translate -pos.i, -pos.j

	class Square extends Rectangle
		size: 0
		
		constructor: (size) ->
			super size, size
		
		define: (size) ->
			super size, size###