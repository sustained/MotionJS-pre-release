define ->
	{Vector} = Math

	class TileSetAnimation
		frame: null
		paused: true
		time:null
		constructor: (options = {}) ->
			@time = 0
			@tileset  = options.tileset  or null
			@sequence = options.sequence or [1]
			@duration = options.duration or 1
			@position = options.position or new Vector
			@posRender = new Vector
			@frameIndex = -1
			@totalFrames = 0
			if @tileset
				@w = @tileset.size[0]
				@h = @tileset.size[1]
			
			if @sequence.length >= 1
				@frame      = @sequence[0]
				@frameIndex = 0
			
			@frameTime = 0
		
		play: () ->
			@paused = false
		
		pause: ->
			@paused = true
		
		reset: ->
			@setFrame @sequence[0]
			@frameTime = 0
		
		update: (dt, t) ->
			return if @paused is true
			@time += dt

			if @time > @frameTime + @duration
				newFrame   = @frameIndex + 1
				@frameTime = @time
				
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
			@posRender.copy(@position).floor()

			g.beginPath()
			g.drawImage(@tileset.image.domOb,
				((@frame - 1) % @tileset.cellsX) * @w,
				Math.floor((@frame - 1) / @tileset.cellsX) * @h,
				@w, @h,
				@posRender.i, @posRender.j - 4, @w, @h)
			g.closePath()
