#
define ->
	class Tile


	class TileMap
		prerendered: false

		constructor: (@tileset, @grid) ->
			@rows   = @grid.rows
			@cols   = @grid.cols
			@width  = @rows * @tileset.size[0]
			@height = @cols * @tileset.size[1]
			@cellW  = @tileset.size[0]
			@cellH  = @tileset.size[1]
			@cellsX = @tileset.cellsX
			@cellsY = @tileset.cellsY

		render: (g) ->
			if @prerendered
				g.beginPath()
				g.drawImage @prerendered, 0, 0
				g.closePath()

		prerender: () ->
			canvas = jQuery('<canvas>').attr width: @width, height: @height
			canvas.css
					top: '0px'#  '-10000px'
					left: '0px'# '-10000px'
					width:  @width + 'px'
					height: @height + 'px'
					position: 'absolute'
			canvas.appendTo 'body'

			cx = canvas.get(0).getContext '2d'
			cx.clearRect 0, 0, @width, @height

			j = 0
			while j < @cols
				i = 0
				while i < @rows
					cell = @grid.getCell i, j

					if cell isnt false and cell > 0
						sX = ((cell - 1) % @cellsX) * @cellW
						sY = Math.floor((cell - 1) / @cellsX) * @cellH
						dX = i * @cellW
						dY = j * @cellH

						cx.beginPath()
						cx.drawImage @tileset.image.domOb, \
							sX, sY, @cellW, @cellH,
							dX, dY, @cellW, @cellH
						cx.closePath()
					i++
				j++

			canvas.css 'display', 'none'

			@prerendered = canvas.get 0
