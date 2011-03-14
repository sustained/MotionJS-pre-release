define [
	'physics/collision/SAT'
	'math/vector'
], (SAT, Vector) ->
	class World
		gravity: new Vector 0, 0
		
		constructor: (@bounds = [Number.MAX_VALUE, Number.MAX_VALUE]) ->
			@w = @bounds[0]
			@h = @bounds[1]
			
			@groups = 
				player:  {}
				static:  {}
				dynamic: {}
			
			@bodies = {
				static:  {}
				dynamic: {}
			}
			
			@cameras  = {}
			@entities = {}
			
		
		addEntity: (entity) ->
			@entities[entity.id] = entity
			
			if entity.body.static
				@bodies.static[entity.id] = entity.body
			else
				@bodies.dynamic[entity.id] = entity.body
		
		removeEntity: (id) ->
			if id of @entities
				delete @entities[id]
				delete @bodies.static[id]  if id of @bodies.static
				delete @bodies.dynamic[id] if id of @bodies.dynamic
				
				true
			
			false
		
		step: (delta) ->
			for n, entity of @groups.player
				entity.input @game.Input
			
			###
				Broad phase
			###
				
			
			###
				Narrow phase
			###
			
			for i, a of @bodies.dynamic
				continue if a.isAsleep()
				
				A = @entities[i]
				#A.input(@game.Input)
				
				a.applyForce @gravity
				
				# for damping etc.
				#i.damping()
				
				# broad phase
				# ...
				
				# narrow phase
				# ...
				
				skips      = 0
				collisions = 0
				
				for j, b of @bodies.static
					continue if not a.caabb.intersects b.aabb
					
					B = @entities[j]
					
					collision = SAT.test b.shape, a.shape
					
					if collision
						collisions++
						
						#console.log collision
						#if shape.fill is 'blue'
						#	if tick - @lastPortalUse > 0.5
						#		e.position     = shape.portal.position.clone()
						#		@lastPortalUse = tick
						#	break
						
						a.position = a.position.add collision.separation
						
						#Vn = (V . N) * N;
						#Vt = V – Vn;
						#V’ = Vt * (1 – friction) + Vn  * -(elasticity);
						
						vn = Vector.multiply collision.vector, a.velocity.dot collision.vector
						vt = Vector.subtract a.velocity, vn
						
						a.velocity = Vector.add(
							Vector.multiply(vt, 1 - b.cof),
							Vector.multiply(vn,    -b.coe)
						)
						
						B.colliding = true
						A.event.fire 'collision', [collision, b]
					else
						B.colliding = false
				
				###
				for m, j of @bodies.dynamic
					continue if not i.caabb.intersects j.aabb
					
					collision = SAT.test i.shape, j.shape
					
					if collision
						i.event.fire 'collision', [collision, j]
						j.event.fire 'collision', [collision, i]
				###
				
				A.colliding = collisions > 0
				
				# integrate
				a.linIntegrate delta
				#a.angIntegrate delta
				
				A.update @game.Loop.tick
			
			return
		
		render: (context, camera) ->
			for id, entity of @entities
				continue if not camera.aabb.intersects entity.body.aabb
				
				entity.render context
			
			return
		
		randomV: -> new Vector @randomX(), @randomY()
		randomX: -> Math.rand 0, @bounds[0]
		randomY: -> Math.rand 0, @bounds[1]
	
	World