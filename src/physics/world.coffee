define [
	'physics/collision/SAT'
	'math/vector'
], (SAT, Vector) ->
	class World
		gravity: new Vector 0, 0
		
		constructor: (@bounds = [10000, 10000]) ->
			@w = @bounds[0]
			@h = @bounds[1]
			
			@groups = 
				player:  {}
				static:  {}
				dynamic: {}
			
			@cameras  = {}
			@entities = {}
		
		addEntity: (entity) ->
			@entities[entity.id] = entity
			
			if entity.body.static
				@groups.static[entity.id] = entity
			else
				@groups.dynamic[entity.id] = entity
		
		step: (delta) ->
			for n, i of @groups.player
				i.input @game.Input
			
			for n, i of @groups.dynamic
				continue if i.body.isAsleep()
				
				i.body.applyForce @gravity
				
				# for damping etc.
				i.damping()
				
				# broad phase
				# ...
				
				# narrow phase
				
				skips      = 0
				collisions = 0
				
				for m, j of @groups.static
					a = i.body
					b = j.body
					
					continue if not a.caabb.intersects b.aabb
					
					collision = SAT.test b.shape, a.shape
					
					if collision
						collisions++
						
						#console.log collision
						#if shape.fill is 'blue'
						#	if tick - @lastPortalUse > 0.5
						#		e.position     = shape.portal.position.clone()
						#		@lastPortalUse = tick
						#	break
						
						a.position  = a.position.add collision.separation
						
						#Vn = (V . N) * N;
						#Vt = V – Vn;
						#V’ = Vt * (1 – friction) + Vn  * -(elasticity);
						
						vn = Vector.multiply collision.vector, a.velocity.dot collision.vector
						vt = Vector.subtract a.velocity, vn
						
						a.velocity = Vector.add(
							Vector.multiply(vt, 1 - b.cof),
							Vector.multiply(vn,    -b.coe)
						)
						
						b.colliding = true
						i.event.fire 'collision', [collision, j]
					else
						b.colliding = false
				
				a.colliding = collisions > 0
				
				# integrate
				i.body.linIntegrate delta
				
				i.update @game.Loop.tick
			
			return
		
		render: (context, camera) ->
			for id, entity of @groups.static
				continue if not camera.aabb.intersects entity.body.aabb
				
				entity.render context
			
			for id, entity of @groups.dynamic
				continue if not camera.aabb.intersects entity.body.aabb
				
				entity.render context
			
			return
		
		randomV: -> new Vector @randomX(), @randomY()
		randomX: -> Math.rand 0, @bounds[0]
		randomY: -> Math.rand 0, @bounds[1]
	
	World