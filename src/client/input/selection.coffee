#
define [
	'collision/aabb'
], (AABB) ->
	{Vector} = Math
	V = Vector

	class Selection
		selection: null

		aabb: null

		active: false

		start: 0

		from:   null
		to:     null
		center: null

		delay: 0.2

		# todo: camera should be a part of world and not need to be passed
		constructor: (@world, @camera) ->
			@to     = new Vector
			@from   = new Vector
			@center = new Vector

			@aabb      = new AABB
			@selection = []

		length: ->
			@selection.length

		during: (kb, ms) ->
			w = (@from.i - @to.i).abs()
			h = (@from.j - @to.j).abs()
			@aabb.set Vector.lerp(@from, @to, 0.5), [w, h]

			###@aabb.set ms.position, {
				t: @from.j
				b: @to.j
				l: @from.i
				r: @to.i
			}###

		after: (kb, ms) ->
			selection = @world.queryAabbIntersects @aabb
			console.log "#{selection.length} entities selected"
			console.log selection

			# cancel selection
			if selection.length is 0
				if @aabb.w < 3 and @aabb.h < 3
					for id in @selection
						@world.getEntityById(id).selected = false
					@selection = []

				return

			# add to selection
			if kb.shiftKey
				console.log 'add to selection'

				if kb.altKey
					console.log 'add all of type'
					entity    = @world.getEntityById selection[0]
					selection = @world.getEntitiesByClass entity.constructor.name

				for id in selection
					if (index = @selection.indexOf id) isnt -1
						selection.splice index, 1

					@world.getEntityById(id).selected = true

				@selection = @selection.concat selection
				return

			# remove from selection
			if kb.ctrlKey
				console.log 'remove from selection'

				if kb.altKey
					console.log 'remove all of type'
					entity    = @world.getEntityById selection[0]
					selection = @world.getEntitiesByClass entity.constructor.name

				for id in selection
					if (index = @selection.indexOf id) is -1
						continue

					@world.getEntityById(id).selected = false
					@selection.splice index, 1

				return

			console.log 'replace selection'
			# replace selection

			if kb.altKey
				console.log 'replace with all of type'
				entity    = @world.getEntityById selection[0]
				selection = @world.getEntitiesByClass entity.constructor.name

			for id in @selection
				@world.getEntityById(id).selected = false

			@selection = []
			@selection = selection

			for id in @selection
				@world.getEntityById(id).selected = true

		input: (kb, ms, delta, tick) ->
			if ms.left
				mouse = ms.inCamera @camera

				if not @active
					if tick - @start > @delay
						@active = true

						@from.copy(mouse).round()
						@aabb.set @from, 0
						@start = tick

				if @active
					@to.copy(mouse).round()
					@during kb, ms
			else
				if kb.keys.a and kb.ctrlKey
					@selection = @world.entityIds
					for id in @selection
						@world.getEntityById(id).selected = true
					return

				if @active
					@after kb, ms
					@active = false
					@aabb.setExtents 0
					@start  = 0

			if @length() > 0
				move  = new Vector
				speed = if kb.shiftKey then 10 else 1

				if kb.keys.up
					move.j = -speed
				else if kb.keys.down
					move.j =  speed

				if kb.keys.left
					move.i = -speed
				else if kb.keys.right
					move.i =  speed

				for id in @selection
					@world.getEntityById(id).body.moveBy move

	###
	if Motion.env is 'client
		Selection::render = (draw) ->
			if @active
				# ...
			else
				if @selection.length > 0
					# ...
	###

	Selection
