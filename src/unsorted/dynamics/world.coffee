define [
	'collision/sat'
], (SAT) ->
	{Vector} = Math
	
	###
	#	
	###
	class World
		_id = 0
		
		gravity: new Vector 0, 0
		
		bodies: null
		
		visible: {}
		
		constructor: (@bounds = [100000, 100000]) ->
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
			@entityIds = []
			
			@types   = {}
			@classes = {}
		
		createCamera: (name, size) ->
			camera = new Camera
		
		getEntityById: (id) ->
			@entities[id] ? false
		
		getEntitiesByType: (type) ->
			@types[type]
		
		getEntitiesByClass: (klass) ->
			@classes[klass]
		
		addEntity: (entity) ->
			type  = entity.collideType
			klass = entity.constructor.name
			
			entity.world = @
			
			if not @types[type]    then @types[type]    = []
			if not @classes[klass] then @classes[klass] = []
			
			@types[type].push    entity.id
			@classes[klass].push entity.id
			
			bodyType = if entity.body.static then 'static' else 'dynamic'
			@bodies[bodyType][entity.id] = entity.body
			
			@entities[entity.id] = entity
			@entityIds.push entity.id
		
		# return an array of entity ids whose 
		queryAabbIntersects: (aabb, callback) ->
			intersects = []
			
			for id, entity of @entities
				if aabb.intersects entity.body.aabb
					intersects.push entity.id
			
			intersects
		
		queryAabbContains: (aabb, callback) ->
			contains = []
			
			for id, entity of @entities
				continue if exclude.indexOf id isnt -1
				
				if aabb.contains entity.body.aabb
					if callback then callback entity
					contains.push id
			
			contains
		
		removeEntity: (id) ->
			if id of @entities
				#entity.destructor()
				delete @entities[id]
				delete @bodies.static[id]  if id of @bodies.static
				delete @bodies.dynamic[id] if id of @bodies.dynamic
				
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
				A.update @game.loop.delta, @game.loop.tick
			
			for i, a of @bodies.static
				A = @entities[i]
				A.update @game.loop.tick
			
			return
		
		render: (context, camera) ->
			@drawBounds()
			
			for id, entity of @entities
				#continue if not camera.aabb.intersects entity.body.aabb
				entity.render context
			
			return
		
		boundsStyle = {stroke: 'red', width: 2}
		
		drawBounds: ->
			canvas.line new Vector(0, 0), new Vector(@w, 0), boundsStyle
			canvas.line new Vector(0, 0), new Vector(0, @h), boundsStyle
			
			canvas.line new Vector(@w, @h), new Vector(0, @h), boundsStyle
			canvas.line new Vector(@w, @h), new Vector(@w, 0), boundsStyle
		
		randomV: -> new Vector @randomX(), @randomY()
		randomX: -> Math.rand 0, @bounds[0]
		randomY: -> Math.rand 0, @bounds[1]
	
	World