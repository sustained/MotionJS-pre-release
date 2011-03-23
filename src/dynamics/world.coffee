define [
	'collision/sat'
	'math/vector'
], (SAT, Vector) ->
	class World
		_id = 0
		
		gravity: new Vector 0, 0
		
		bodies: null
		
		visible: {}
		
		constructor: (@bounds = [Number.MAX_VALUE, Number.MAX_VALUE]) ->
			@id = _id++
			
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
		
		addCamera: () ->
			
		
		addEntity: (entity) ->
			@entities[entity.id] = entity
			
			@bodies[if entity.body.static then 'static' else 'dynamic'][entity.id] = entity.body
		
		removeEntity: (id) ->
			if entity of @entities
				entity.destructor()
				#delete @entities[id]
				#delete @bodies.static[id]  if id of @bodies.static
				#delete @bodies.dynamic[id] if id of @bodies.dynamic
				
				true
			
			false
		
		step: (delta) ->
			for i, a of @bodies.dynamic
				a.collisions = []
				
				#continue if a.isAsleep()
				
				A = @entities[i]
				#A.colliding = false
				#A.input(@game.Input)
				
				a.applyForce(@gravity) if a.gravity
				
				if a.collide
					for j, b of @bodies.static
						B = @entities[j]
						
						if not (A.collideWith & B.collideType) or not b.collide or
						   not a.caabb?.intersects b.aabb then continue
						###
						if not (A.collideWith & B.collideType)
							console.log 'wrong collision type'
							continue
						
						if not b.collide
							console.log 'not collide'
							continue
						
						if not a.caabb?.intersects b.aabb
							console.log 'caabb doesnt intersect'
							continue
						###
						#continue if not b.collide or not a.caabb.intersects b.aabb
						
						collision = SAT.test b.shape, a.shape, true
						
						if collision
							if A.collide collision, B
								a.collideStatic collision, b
					
					for k, c of @bodies.dynamic
						C = @entities[k]
						
						if not (A.collideWith & C.collideType) or not b.collide or
						   not a.caabb.intersects(c.aabb) or i is k
							continue
						
						collision = SAT.test c.shape, a.shape, false
						
						if collision
							if A.collide collision, C
								a.collideDynamic collision, c
				
				# integrate
				#a.linIntegrate delta
				#a.angIntegrate delta
				a.integrate delta
				A.update @game.Loop.delta, @game.Loop.tick
			
			for i, a of @bodies.static
				A = @entities[i]
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