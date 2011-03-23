define [
	'entity'
	'geometry/polygon'
	'geometry/rectangle'
	'collision/aabb'
	'colour'
], (Entity, Polygon, Rectangle, AABB, Colour) ->
	{Vector} = Math
	
	class Powerup extends Entity.Static
		constructor: (size = [20, 20]) ->
			super
			
			@collideType = 0x4
			
			@body.shape    = Polygon.createRectangle size[0], size[1]#new Rectangle size[0], size[1]
			@body.aabb.setExtents @body.shape.calculateAABBExtents()
			@body.position = new Vector Math.rand(50, world.w - 50), Math.rand(50, world.h - 50)
			
			@going  = 'up'
			@alpha  = 0.0
			@change = 0.01
			@colour = new Colour(0, 255, 0)
		
		update: () ->
			if @alpha >= 1.00
				@going = 'down'
			else if @alpha <= 0.00
				@going = 'up'
			
			if @going is 'up'
				@alpha += 0.01
			else
				@alpha -= 0.01
			
			@colour.a Math.clamp @alpha, 0.0, 1.0
		
		render: (context) ->
			@body.shape.fill = @colour.rgba()
			@body.shape.draw context
			
			canvas.polygon [
				new Vector @body.aabb.l, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.b
				new Vector @body.aabb.l, @body.aabb.b
			], stroke: 'rgba(0, 255, 0, 0.5)'
		
		collide: (collision) ->
			console.log collision
		
	Powerup