define [
	'motion'
], (Motion) ->
	class Loop
		time:  0 # current time
		tick:  0 # game tick
		tock:  0
		alpha: 0 # alpha for animation
		delta: 0.016666666666666666 #0.02
		accum: 0 # accumulator
		
		update: 0 # update frame number
		render: 0 # render frame number
		
		# interval ids
		gameLoop:  null
		frameLoop: null
		
		context: null
		
		onUpdate: -> null
		onRender: -> null
		
		constructor: (@Game) ->
			if Motion.env is 'client'
				@fpsUpdate = $('<p />')
				@fpsRender = $('<p />')
				css = 
					position: 'absolute'
					zIndex: 9999
					background: '#121212'
					border: '2px solid #040404'
					fontFamily: 'sans-serif'
					color: '#b3b3b3'
					fontWeight: 'normal'
					margin: '0px'
					padding: '3px'
					height: '16px'
					lineHeight: '16px'
					#'webkit-border-radius': '5px'
				
				@fpsUpdate.css(css).css(top:'10px', left:'10px').attr 'id', 'fpsUpdate'
				@fpsRender.css(css).css(top:'45px', left:'10px').attr 'id', 'fpsRender'
				@fpsUpdate.add(@fpsRender).appendTo 'body'
			else
				@frameRate = noop
			
			@time   = Date.now()
			@deltas = [];
			
			haveGame  = isObject(@Game) #and @Game.class() is 'Game'
			@onUpdate = @Game.Screen.method 'update' if haveGame
			@onRender = @Game.Screen.method 'render' if haveGame
		
		start: ->
			@currentTime = Date.now()
			
			@gameLoop  = window.setInterval (=> @loop()), 10
			#@frameLoop = window.setInterval (=> @frameRate()), 1000 if Motion.env is 'client'
		play: @::start
		
		stop: ->
			window.clearInterval @gameLoop
			#window.clearInterval @frameLoop if Motion.env is 'client'
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
			average = @deltas.sum()
			@fpsUpdate.text 'Update @ ' + (@update - @lastUpdate) + ' FPS'
			@fpsRender.text 'Render @ ' + (1 / (average / length)).toFixed(0) + ' FPS'
		
		loop: ->
			time  = Date.now()
			delta = (time - @time) / 1000
			
			delta   = 0.25 if delta > 0.25
			@deltas = [] if @deltas.push(delta) > 42
			
			@time   = time
			@accum += delta
			
			while @accum >= @delta
				@accum  -= @delta
				@update += 1
				@tick   += @delta
				
				@onUpdate @tick
				
			if @tick - @tock > 1
				@tock = @tick
				@frameRate()
				@lastUpdate = @update
			
			@alpha   = @accum / @delta
			@render += 1
			
			@onRender()
	
	Loop