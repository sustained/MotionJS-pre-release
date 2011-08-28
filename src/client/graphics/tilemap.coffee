define ->
	class Tile
		

	class TileMap
		constructor: (@tileset, @tilemap) ->
			@screenTilesX = 1024 / @tileset.size[0]
			@screenTilesY =  768 / @tileset.size[1]
			
			@mapTilesX = @tilemap[0].length
			@mapTilesY = @tilemap.length
			
			@width  = @mapTilesX * @tileset.size[0]
			@height = @mapTilesY * @tileset.size[1]
			
			@prerendered = null

		prerender: () ->
			###
			tmp = Canvas.createBuffer([@width, @height])
			tmp.clear()
			###
			#console.log @tileset
			canvas = jQuery('<canvas>').attr width: @width, height: @height
			canvas.css
					top: '0px'#  '-10000px'
					left: '0px'# '-10000px'
					width:  @width + 'px'
					height: @height + 'px'
					position: 'absolute'
			canvas.appendTo 'body'
			
			cx = canvas.get(0).getContext '2d'
			
			cx.clearRect 0, 0, 1024, 768
			
			cellsX = @tileset.image.width  / @tileset.size[0]
			cellsY = @tileset.image.height / @tileset.size[1]
			
			j = 0 ;; while j < @mapTilesY
				i = 0 ;; while i < @mapTilesX
					tileNumber = @tilemap[j][i]
					if tileNumber > 0
						sX = ((tileNumber - 1) % cellsX) * 16
						sY = Math.floor((tileNumber - 1) / cellsX) * 16
						dX = i * 16
						dY = j * 16
						cx.beginPath()
						cx.drawImage @tileset.image.domOb, sX, sY, 16, 16, dX, dY, 16, 16
						cx.closePath()
					i++
				j++
			
			#canvas.css 'display', 'none'
			
			@prerendered = canvas.get 0
