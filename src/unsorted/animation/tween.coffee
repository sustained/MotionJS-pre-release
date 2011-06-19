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
			none:    0
			cycle:   1
			restart: 2

		start:     null
		end:       null
		object:    null
		property:  null
		listener:  null

		time:     0
		duration: 0

		active: true

		loop:   Tween.LOOP.none
		easing: Easing.linear

		getReference: -> @object[@property]

		setLoop: (val) ->
			return if not val?
			if String.isString(val)
				return false if null is (val = resolveDotPath(val, Tween.LOOP))
			@loop = val
		
		setEasing: (val) ->
			return if not val?
			if String.isString(val)
				return false if null is (val = resolveDotPath(val, Easing))
			@easing = val
		
		setObject: (object, property) ->
			if property? and object[property]?
				@object   = object
				@property = property
			else
				if Array.isArray object
					[@object, @property] = object
		
		setDuration: (duration) ->
			@duration = duration if duration?
		
		setKeyFrames: (start, end) ->
			@end    = end if end?
			@start  = start if start?
			@change = @calculateChange() if @start? and @end?
		
		constructor: (opts = {}) ->
			@setObject opts.object, opts.property

			if (ref = @getReference())?
				Object.extend @, if Vector.isVector(ref) then VectorTween else NumberTween
				@start = ref if not @start?

			@setKeyFrames opts.start, opts.end

			@setLoop   opts.loop
			@setEasing opts.easing

			@setDuration opts.duration
			@active = opts.active or @active
			console.log 'Tween', @
		
		play:  -> @active = true
		pause: -> @active = false ; @time = 0

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
				@pause()
				@setReference @lerp @start, @change, 1.0
				@listener(@) if @listener?

				if @loop isnt Tween.LOOP.none
					@play()

					if @loop is Tween.LOOP.cycle
						@setKeyFrames @end, @start
			else
				@tick()
