define ->
	{Event} = Motion
	{throttle} = _

	class Loop
		@INTERVAL_WAIT: 5
		@USE_REQUESTANIMFRAME: true

		_animFrame:  null
		_intervalId: null
		_running:    false

		_enter:  -> undefined
		_leave:  -> undefined
		_update: -> undefined

		time:  0
		tick:  0
		tock:  0
		accum: 0
		delta: 1.0 / 60

		loopRate:   0
		updateRate: 0

		loopCount:   0
		updateCount: 0

		_timer: null

		register: (object) ->
			@_enter = object.enter
			@_frame = object.update
			@_leave = object.leave

		constructor: (options = {}) ->
			@[k] = v for k,v of options

			@fps    = throttle @frameRate, 250
			@time   = Date.now()
			@deltas = []
			@event  = new Event ['enter', 'frame', 'leave'], binding: @

			if @constructor.USE_REQUESTANIMFRAME
				@_start = => @_timer = requestAnimFrame @loop.bind @
				@_stop  = => cancelAnimFrame @_timer
				@event.on 'enter', -> @_start()
			else
				@_start = => @_timer = setInterval @loop.bind(@), @constructor.INTERVAL_WAIT
				@_stop  = => clearInterval @_timer

			#@event.on 'leave', ->
			#	@_animFrame = requestAnimFrame @_leave.bind @

		start: ->
			return if @_running is true
			@time        = Date.now()
			@_running    = true
			#@_intervalId = setInterval @loop.bind(@), Loop.INTERVAL_WAIT
			#@_animFrame = requestAnimFrame @loop.bind @
			@_start()

		stop: ->
			return if @_running is false
			@_running = false
			#clearInterval @_intervalId
			#cancelAnimFrame @_animFrame
			@_stop()

		play:  @::start
		pause: @::stop

		reset: ->
			@time = @tick = @tock = @accum = 0
			@loopRate = @loopCount = @updateRate = @updateCount = 0
			@deltas = []

		restart: ->
			@stop()
			@reset()
			@start()

		loop: ->
			@event.fire 'enter'
			@_enter()

			time    = Date.now()
			delta   = (time - @time) / 1000
			#delta   = 0.25 if delta > 0.25

			@loopRate   = 1.0 /  delta
			@updateRate = 1.0 / @delta
			#@deltas = [delta] if @deltas.push(delta) > 60

			@time   = time
			@accum += delta

			while @accum >= @delta
				@event.fire 'frame', [@delta, @tick]
				@_update()
				@updateCount++
				@tick  += @delta
				@accum -= @delta

			#@alpha = @accum / @delta
			@event.fire 'leave'
			@_leave()
