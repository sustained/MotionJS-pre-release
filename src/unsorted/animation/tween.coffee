define [
	'unsorted/animation/easing'
], (Easing) ->
	{Vector} = Math

	class Tween
		@LOOP:
			none:    0
			cycle:   1
			restart: 2
		
		#_lerpNum = -> @setter Math.lerp   @start, @end, @time / @duration
		#_lerpVec = -> @setter Vector.lerp @start, @end, @time / @duration

		start: null
		end:   null

		time: 0
		loop: false
		active: false
		easing: null
		duration: 0

		listener:  null
		reference: null

		constructor: (options = {}) ->
			Object.extend @, options

			if @reference? and Vector.isVector(@reference)
				@set  = (v) => @reference.copy c
				@get  = (v) => @reference.clone()
				@lerp = Vector.lerp
			else
				[@object, @property] = @reference if Array.isArray(@reference)
				
				if not @object? or not @property?
					console.log '[Tween]: Required options.object and/or property not present.'
				
				@set  = (v) => @object[@property] = v
				@get  = (v) => @object[@property]
				@lerp = Math.lerp2

			@start  = @get() if not @start?
			@change = @end - @start
			@active = true unless options.active is false

			console.log 'Tween', @
		
		doTick: ->
			l = @time / @duration
			l = @easing(l) if @easing?
			@set @lerp @start, @change, l

		onTick: (tick, bind...) ->
			@tick = tick.bind(@, bind...) if Function.isFunction tick
		
		tick: -> @doTick()

		update: (dt, t) ->
			return if @active is false
			@time += dt

			if @time >= @duration
				@time   = 0
				@active = false
				@set @lerp @start, @change, 1.0
				@listener(@) if @listener?

				if @loop isnt false
					@active = true
					if @loop is Tween.LOOP.cycle
						[@start, @end] = [@end, @start]
						@change = @end - @start
					#else if @loop is Tween.LOOP.restart
			else
				@tick()
