define ->
	class TileSetAnimation
		frame: null
		paused: false
		
		constructor: (options = {}) ->
			@tileset  = options.tileset  or null
			@sequence = options.sequence or [1]
			@duration = options.duration or 1
			@position = options.position or [0, 0]
			@frameIndex = -1
			
			if @tileset
				@w = @tileset.size[0]
				@h = @tileset.size[1]
			
			if @sequence.length >= 1
				@frame = @sequence[0]
			
			@frameTime = 0
		
		play: ->
			@paused = false
		
		pause: ->
			@paused = true
		
		update: (dt, t) ->
			return if @paused is true
			
			if t > @frameTime + @duration
				newFrame   = @frameIndex + 1
				@frameTime = t
				
				if newFrame > @sequence.length - 1
					@frame      = @sequence[0]
					@frameIndex = 0
				else
					@frame      = @sequence[newFrame]
					@frameIndex = newFrame
				
				#console.log "#{@frameIndex}: frame #{@frame}"
		
		render: (g) ->
			g.beginPath()
			g.drawImage(
				@tileset.image.domOb, (@frame - 1) * @w, 0, @w, @h, @position[0], @position[1], @w, @h
			)
			g.closePath()
