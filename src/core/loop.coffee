define ->
	_initClient = ->
		@fpsUpdate = jQuery '<p />'
		@fpsRender = jQuery '<p />'
		
		css = {
			position: 'absolute', zIndex: 9999
			
			background: '#121212', color: '#b3b3b3'
			
			fontFamily: 'sans-serif', fontWeight: 'normal'
			
			padding: '3px', margin: '0px', border: '2px solid #040404'
			
			height: '16px', lineHeight: '16px'
		}
		
		@fpsUpdate.css(css).css(top:'10px', left:'10px').attr 'id', 'fpsUpdate'
		@fpsRender.css(css).css(top:'45px', left:'10px').attr 'id', 'fpsRender'
		
		@fpsUpdate.add(@fpsRender).appendTo('body')#.hide()
	
	_initServer = ->
		
	
	class Loop
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
			@gameLoop    = setInterval (=> @loop()), 1
		
		stop: ->
			clearInterval @gameLoop
		
		play:  @::start
		pause: @::stop
		
		reset: ->
			@time = @tick = @tock = @accum = @update = @render = 0
		
		showFPS: ->
			@showFPS = true
			@fpsUpdate.add(@fpsRender).show()
		
		hideFPS: ->
			@showFPS = false
			@fpsUpdate.add(@fpsRender).hide()
		
		frameRate: ->
			return if @showFPS is false
			
			length  = @deltas.length
			average = Array.sum @deltas
			@fpsUpdate.text 'Update @ ' + (@update - @lastUpdate) + ' FPS'
			@fpsRender.text 'Render @ ' + (1 / (average / length)).toFixed(0) + ' FPS'
		
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
			
			if @tick - @tock > 1
				@tock = @tick
				@frameRate()
				@lastUpdate = @update
			
			@alpha = @accum / @delta
			
			@_onRender @alpha
			@render += 1
