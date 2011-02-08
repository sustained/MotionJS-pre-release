define ['motion', 'geometry/shape'], (Motion, Shape) ->
	class Circle extends Shape
		radius: 0
		
		constructor: (@radius, position) ->
			super position
		
		@get 'radiusT', -> @radius * @_scaleX
		
		draw: (graphics) ->
			graphics.fillStyle   = @fill   if @fill
			graphics.strokeStyle = @stroke if @stroke
			graphics.beginPath()
			graphics.arc @position.i, @position.j, @radiusT, 0, Math.TAU, false
			graphics.closePath()
	
	Circle
