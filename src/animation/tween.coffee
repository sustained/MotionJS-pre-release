#
define [
	'utilities/string'
	'animation/easing'
], (StringUtils, Easing) ->
	{resolveDotPath} = StringUtils
	{Vector} = Math
	{isVector} = Vector
	{extend, isArray, isFunction, isString} = _

	NumberTween =
		lerp: Math.lerp
		setReference: (n) -> @object[@property] = n
		calculateChange:  -> @end - @start

	VectorTween =
		lerp: Vector.lerp
		setReference: (v) -> @object[@property].copy v
		calculateChange:  -> Vector.subtract @end, @start

	class Tween
		@SUPPORT:
			Number:
				lerp: Math.lerp
			Vector:
				lerp: Vector.lerp
				set: (v) -> @object[@property].copy v
				change:  -> Vector.subtract @end, @start

		@LOOP:
			none:   0 # tween will only run once
			cycle:  1 # tween will cycle between start and end
			repeat: 2 # tween will go from start to end, over and over

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
			if isString(val)
				return false if null is (val = resolveDotPath(val, Tween.LOOP))
			@loop = val

		setEasing: (val) ->
			return if not val?
			if isString(val)
				return false if null is (val = resolveDotPath(val, Easing))
			@easing = val

		setObject: (object, property) ->
			if property? and object[property]?
				@object   = object
				@property = property
			else
				if isArray object
					[@object, @property] = object

		setDuration: (duration) ->
			@duration = duration if duration?

		from: (from) -> @setKeyFrames from, null
		to:   (to)   -> @setKeyFrames null, to

		setKeyFrames: (start, end) ->
			@end    = end if end?
			@start  = start if start?
			@change = @calculateChange() if @start? and @end?

		constructor: (opts = {}, opts2 = {}) ->
			if isArray opts
				@setObject opts[0], opts[1]
				opts = opts2
			else
				@setObject opts.object, opts.property

			ref = @getReference()

			if (ref = @getReference())?
				extend @, if isVector(ref) then VectorTween else NumberTween
				@start = ref if not @start?

			@setKeyFrames opts.start, opts.end

			@setLoop   opts.loop
			@setEasing opts.easing

			@setDuration opts.duration
			@active = opts.active or @active
			#console.log 'Tween', @

		play:    -> @active = true
		pause:   -> @active = false
		restart: -> @pause() ; @time = 0 ; @play()

		doTick: ->
			l = @time / @duration
			l = @easing(l) if @easing?
			@setReference @lerp @start, @change, l

		onTick: (tick, bind...) ->
			@tick = tick.bind(@, bind...) if isFunction tick

		tick: -> @doTick()

		update: (dt, t) ->
			return if @active is false
			@time += dt

			if @time >= @duration
				@pause()
				@setReference @lerp @start, @change, 1.0
				@listener(@) if @listener?

				if @loop isnt Tween.LOOP.none
					if @loop is Tween.LOOP.cycle
						@setKeyFrames @end, @start
						@restart()
					else if @loop is Tween.LOOP.repeat
						@restart()
			else
				@tick()
