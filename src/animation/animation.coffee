define [
	'animation/easing'
], (Easing) ->
	{Vector} = Math
	
	class Animation
		end:   0
		start: 0
		
		repeat:    false
		active:    false
		easing:    null
		duration:  1
		listener:  null
		reference: null
		
		endTime:   0
		currTime:  0
		startTime: 0
		
		constructor: (options) ->
			Motion.extend @, options
			
			#if @reference
				#@start = @reference#.clone()
			
			#if not @reference then throw 'no reference passed to animation'
			#if not @easing    then @easing = Easing[if isVector(@reference) then 'Vector' else 'Scalar'].linear
			#if not @start     then @start  = @reference.position.clone()
		
		update: (delta) ->
			@currTime += delta
			
			if @currTime > @endTime
				@stop()
			else
				@step()
		
		step: ->
			t = @currTime / @duration
			@reference.a(Math.lerp @start, @end, t)
			#v = @easing(@start, @end, t)
			#t = Math.remap @currTime, [0, @duration], [0, 1]
			#@reference.copy Vector.lerp @start, @end, t
			#console.log v.debug()
		
		play: ->
			@active  = true
			@endTime = @duration
		
		stop: ->
			@active = false
			@reference.a(@end)#.position = @end
			
			#if listener? then listener.event.fire ...
	
	Animation
