define [
	'entity'
	'geometry/polygon'
	'geometry/rectangle'
	'collision/aabb'
], (Entity, Polygon, Rectangle, AABB) ->
	{Vector} = Math
	
	class Wall extends Entity.Static
		constructor: (size = [Math.rand(100, 400), Math.rand(20, 40)]) ->
			super
			
			@collideType = 0x2
			
			@body.shape    = Polygon.createRectangle size[0], size[1]#new Rectangle size[0], size[1]
			@body.aabb.setExtents @body.shape.calculateAABBExtents()
			
			@body.position = new Vector Math.rand(50, world.w - 50), Math.rand(50, world.h - 50)

		render: (context) ->
			@body.shape.draw context
			canvas.polygon [
				new Vector @body.aabb.l, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.b
				new Vector @body.aabb.l, @body.aabb.b
			], stroke: 'rgba(0, 255, 0, 0.5)'
			#canvas.text @body.position.clone(), "#{@body.x}, #{@body.y}", fill: 'white'

	Wall