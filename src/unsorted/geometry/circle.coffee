#
define [
	'geometry/shape'
], (Shape) ->
	class Circle extends Shape
		radius: 0

		constructor: (@radius, position) ->
			super position

		@get 'radiusT', -> @radius * @_scaleX

		draw: (g) ->
			g.beginPath()
			g.arc @position.i, @position.j, @radiusT, 0, Math.TAU, false
			g.closePath()

			if @fill
				g.fillStyle = @fill
				g.fill()

			if @stroke
				g.strokeStyle = @stroke
				g.stroke()

	Circle
