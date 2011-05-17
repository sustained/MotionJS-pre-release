define ->
	class Tile
	
	class TileMap
		constructor: (@tileset, @tilemap) ->
			@screenTilesX = 1024 / @tileset.size
			@screenTilesY =  768 / @tileset.size
			
			@mapTilesX = @tilemap[0].length
			@mapTilesY = @tilemap.length
			
			@width  = @mapTilesX * @tileset.size
			@height = @mapTilesY * @tileset.size
			
			@prerendered = null
		
		get: (number) ->
			###{
				x: number % @mapTilesX
				y:
			}
			@tilemap[Math.round number / @cellsY][number % @cellsX]###
		
		prerender: () ->
			console.log @tileset
			canvas = jQuery('<canvas>').attr width: @width, height: @height
			canvas.css
					top:  '-10000px'
					left: '-10000px'
					width:  @width + 'px'
					height: @height + 'px'
					position: 'absolute'
			canvas.appendTo 'body'
			
			cx = canvas.get(0).getContext '2d'
			
			cx.clearRect 0, 0, 1024, 768
			
			cellsX = @tileset.image.width  / @tileset.size
			cellsY = @tileset.image.height / @tileset.size
			
			j = 0 ;; while j < @mapTilesY
				i = 0 ;; while i < @mapTilesX
					tileNumber = @tilemap[j][i]
					
					sX = ((tileNumber - 1) % cellsX) * 16
					#sY = (Math.max(1, (Math.round(tileNumber / cellsX))) - 1) * 16
					sY = Math.floor((tileNumber - 1) / cellsX) * 16
					dX = i * 16
					dY = j * 16
					
					#console.log tileNumber
					#console.log "s #{sX},#{sY} - d #{dX},#{dY}"
					#console.log sY
					
					#if dX >= 0 && dX <= 1024 and
					#   dY >= 0 && dY <=  768
					cx.beginPath()
					cx.drawImage @tileset.image.domOb, sX, sY, 16, 16, dX, dY, 16, 16
					cx.closePath()
					
					i++
				j++
			
			canvas.css 'display', 'none'
			
			@prerendered = canvas.get 0
