define ->
	class Loop
		@INTERVAL_WAIT: 5

		_intervalId: null
		_running:    false

		_enter:  ->
		_leave:  ->
		_update: ->

		time:  0
		tick:  0
		tock:  0
		accum: 0
		delta: 1.0 / 60
		
		loopRate:    0
		loopCount:   0
		updateRate:  0
		updateCount: 0
		
		constructor: (options = {}) ->
			Object.extend @, options
			
			@time   = Date.now()
			@deltas = []
		
		start: ->
			return if @_running is true
			@time        = Date.now()
			@_running    = true
			@_intervalId = Motion.root.setInterval @loop.bind(@), Loop.INTERVAL_WAIT
		
		stop: ->
			return if @_running is false
			@_running = false
			Motion.root.clearInterval @_intervalId
		
		play:  @::start
		pause: @::stop
		
		reset: ->
			@time = @tick = @tock = @accum = 0
			@loopRate = @loopCount = @updateRate = @updateCount = 0
			@deltas = []
		
		restart: ->
			@stop() ; @reset() ; @start()
		
		frameRate: ->
			length  = @deltas.length
			average = Array.sum @deltas

			@loopRate   = (1 / (average / length)).toFixed 0
			@updateRate = 1.0 / @delta
		
		loop: ->
			time = Date.now()

			delta   = (time - @time) / 1000
			delta   = 0.25 if delta > 0.25
			@deltas = [delta] if @deltas.push(delta) > 60
			
			@time   = time
			@accum += delta
			
			@_enter()

			while @accum >= @delta
				@_update()
				@updateCount++
				@tick  += @delta
				@accum -= @delta
			
			@_leave()
			@loopCount++

			if @tick - @tock > 1
				@tock = @tick
				@frameRate()
			
			#@alpha = @accum / @delta
