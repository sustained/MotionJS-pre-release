define ->
	pad = (number, length, pad = '0') ->
		str = "#{number}"
		str = pad + str while str.length < length
		str
	
	_initClient = ->
		@fpsContainer = jQuery '<div />'
		@fpsUpdate    = jQuery '<p>Update @ <span></span> FPS</p>'
		@fpsRender    = jQuery '<p>Render @ <span></span> FPS</p>'

		@fpsContainer.attr 'id', 'motionFpsContainer'

		jQuery('span', @fpsUpdate).html '&nbsp;&nbsp;0'
		jQuery('span', @fpsRender).html '&nbsp;&nbsp;0'

		@fpsUpdate.add(@fpsRender).appendTo @fpsContainer.appendTo 'body'
	
	_initServer = ->
	
	class Loop
		@INTERVAL_WAIT: 2 # setInterval interval

		time:  0 # current time
		tick:  0 # game tick
		tock:  0
		alpha: 0 # alpha for animation
		delta: 1.0 / 60
		accum: 0 # accumulator
		
		update: 0 # update frame number
		lastUpdate: 0
		render: 0 # render frame number
		
		# interval ids
		gameLoop:  null
		frameLoop: null
		showFPS: true

		context: null
		
		_onUpdate: ->
		_onRender: ->
		
		constructor: (@game, options = {}) ->
			@delta = options.delta if options.delta?
			
			# move this shit
			if Motion.env is 'client'
				_initClient.call @
			else
				_initServer.call @
			
			@time   = Date.now()
			@deltas = []
		
		start: ->
			@currentTime = Date.now()
			@gameLoop    = setInterval @loop.bind(@), Loop.INTERVAL_WAIT
		
		stop: ->
			clearInterval @gameLoop
			jQuery('span', @fpsUpdate).html '&nbsp;&nbsp;0'
			jQuery('span', @fpsRender).html '&nbsp;&nbsp;0'
		
		play:  @::start
		pause: @::stop
		
		reset: ->
			@time = @tick = @tock = @accum = @update = @render = 0
		
		showFps: ->
			@showFPS = true
			@fpsContainer.show()
		
		hideFps: ->
			@showFPS = false
			@fpsContainer.hide()
		
		frameRate: ->
			length  = @deltas.length
			average = Array.sum @deltas

			updateRate = @update - @lastUpdate
			renderRate = (1 / (average / length)).toFixed 0

			jQuery('span', @fpsUpdate).html pad(updateRate, 3, '&nbsp;')
			jQuery('span', @fpsRender).html pad(renderRate, 3, '&nbsp;') if not isNaN renderRate
		
		fps: 0
		
		loop: ->
			time  = Date.now()
			delta = (time - @time) / 1000
			delta = 0.25 if delta > 0.25
			@deltas = [] if @deltas.push(delta) > 60
			
			#@fps    = 1.0 / delta if @update % 15 is 0
			@time   = time
			@accum += delta
			
			while @accum >= @delta
				@_onUpdate @tick
				@tick   += @delta
				@accum  -= @delta
				@update += 1
			
			if @showFPS is true and @tick - @tock > 1
				@tock = @tick
				@frameRate()
				@lastUpdate = @update
			
			@alpha = @accum / @delta
			
			@_onRender @alpha
			@render += 1
