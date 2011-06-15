define [
	'unsorted/animation/easing'
], (Easing) ->
	{Vector} = Math

	NumberTween =
		lerp: Math.lerp
		setReference: (n) -> @object[@property] = n
		getReference:     -> @object[@property]
		calculateChange:  -> @end - @start
	
	VectorTween =
		lerp: Vector.lerp
		setReference: (v) -> @object.copy v
		getReference:     -> @object.clone()
		calculateChange:  -> Vector.subtract @end, @start

	class Tween
		@LOOP:
			none: 0
			cycle: 1
			restart: 2

		start:     null
		end:       null
		object:    null
		property:  null
		listener:  null

		time:     0
		duration: 0

		loop:   false
		active: false

		easing: Easing.smooth

		constructor: (options = {}) ->
			Object.extend @, options
			Object.extend @, if Vector.isVector(@object) then VectorTween else NumberTween
			
			@start  = @getReference() if not @start?
			@change = @calculateChange()
			@active = true unless options.active is false

			console.log 'Tween', @
		
		play: -> @active = true
		stop: -> @active = false

		doTick: ->
			l = @time / @duration
			l = @easing(l) if @easing?
			@setReference @lerp @start, @change, l

		onTick: (tick, bind...) ->
			@tick = tick.bind(@, bind...) if Function.isFunction tick
		
		tick: -> @doTick()

		update: (dt, t) ->
			return if @active is false
			@time += dt

			if @time >= @duration
				@time   = 0
				@active = false
				@setReference @lerp @start, @change, 1.0
				@listener(@) if @listener?

				if @loop isnt Tween.LOOP.none
					@active = true
					if @loop is Tween.LOOP.cycle
						[@start, @end] = [@end, @start]
						@change = @end - @start
					#else if @loop is Tween.LOOP.restart
			else
				@tick()
