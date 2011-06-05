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
		
		reset: ->
			@setFrame @sequence[0]
		
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
		
		setFrame: (frame) ->
			@frame      = frame
			@frameIndex = @sequence.indexOf frame
		
		render: (g) ->
			g.beginPath()
			g.drawImage(@tileset.image.domOb,
				((@frame - 1) % @tileset.cellsX) * @w,
				Math.floor((@frame - 1) / @tileset.cellsX) * @h,
				@w, @h,
				Math.floor(@position[0]), Math.floor(@position[1]), @w, @h)
			g.closePath()
