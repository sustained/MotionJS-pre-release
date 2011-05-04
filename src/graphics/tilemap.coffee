define ->
	class Tile
	
	class TileMap
		constructor: (@tileset) ->
			@layers = {
				base: []
			}
			
			w = 1024 / 16
			h =  768 / 16
			
			j = 0 ; while j < h
				@layers.base.push []
				
				i = 0 ; while i < w
					@layers.base[j].push new Tile
					i++
				 
				j++
			
			console.log @layers.base
