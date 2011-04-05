define [
	'entity'
	'geometry/polygon'
	'geometry/rectangle'
	'collision/aabb'
	'colour'
], (Entity, Polygon, Rectangle, AABB, Colour) ->
	{Vector} = Math
	
	class Weapon extends Entity.Dynamic
		constructor: (size = [20, 20]) ->
			super
			
			@collideWith = 0x1 | 0x2
			@collideType = 0x8
			
			@body.shape    = Polygon.createRectangle size[0], size[1]#new Rectangle size[0], size[1]
			@body.aabb.setExtents @body.shape.calculateAABBExtents()
			@body.caabb = new AABB @body.position, 20
			@body.position = new Vector Math.rand(50, world.w - 50), Math.rand(50, world.h - 50)
		
		update: ->
			vel = @body.velocity.clone()
			
			if vel.i < 0
			 	@body.caabb.setLeft  Math.max 50, vel.i.abs()
				@body.caabb.setRight 50
			
			if vel.i > 0
				@body.caabb.setLeft  50
				@body.caabb.setRight Math.max 50, vel.i
			
			if vel.j < 0
				@body.caabb.setTop    Math.max 50, vel.j.abs()
				@body.caabb.setBottom 50
			
			if vel.j > 0
				@body.caabb.setTop    50
				@body.caabb.setBottom Math.max 50, vel.j
			
			@body.aabb.setPosition  @body.position
			@body.caabb.setPosition @body.position
		
		render: (context) ->
			@body.shape.draw context
		
		collide: (collision, entity) ->
			#if entity.type is Entity.types.player
			if entity.collideType is 0x1
				entity.hasAGun = true
				@world.removeEntity @id
				
				false
			
			true
	
	Weapon