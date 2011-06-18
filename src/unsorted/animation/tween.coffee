define [
	'shared/utilities/string'

	'unsorted/animation/easing'
], (StringUtils, Easing) ->
	{Vector} = Math
	{resolveDotPath} = StringUtils

	NumberTween =
		lerp: Math.lerp
		setReference: (n) -> @object[@property] = n
		calculateChange:  -> @end - @start
	
	VectorTween =
		lerp: Vector.lerp
		setReference: (v) -> @object[@property].copy v
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

		active: true

		loop:   'none'
		easing: 'smooth'

		getReference: -> @object[@property]

		setLoop: (val) ->
			if String.isString(val)
				return false if null is (val = resolveDotPath(val, Tween.LOOP))
			@loop = val
		
		setEasing: (val) ->
			if String.isString(val)
				return false if null is (val = resolveDotPath(val, Easing))
			@easing = val

		constructor: (options = {}) ->
			Object.extend @, options

			if Vector.isVector(@object[@property])
				Object.extend @, VectorTween
			else
				Object.extend @, NumberTween
			
			@start  = @getReference() if not @start?
			@change = @calculateChange() if @start? and @end?

			@setLoop @loop if @loop?
			@setEasing @easing if @easing?
		
		play: -> @active = true
		stop: -> @active = false ; @time = 0

		doTick: ->
			l = @time / @duration
			l = @easing(l) if @easing?
			@setReference @lerp @start, @change, l
		
		onTick: (tick, bind...) ->
			@tick = tick.bind(@, bind...) if Function.isFunction tick
		
		tick: -> @doTick()

		update: (dt, t) ->
			return if @active is false
			#console.log 'active!'
			@time += dt
			if @time >= @duration
				@stop()
				@setReference @lerp @start, @change, 1.0
				@listener(@) if @listener?

				if @loop isnt Tween.LOOP.none
					@play()
					if @loop is Tween.LOOP.cycle
						console.log 'loop:repeat'
						[@start, @end] = [@end, @start]
						@change = @calculateChange()
			else
				@tick()
