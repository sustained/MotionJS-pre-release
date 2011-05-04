define [
	'assets/image'
], (Img) ->
	class TileSet
		_options = {
			size: 16
		}
		_instances = {}
		
		@get: (name) -> _instances[name]
		
		size:  null
		image: null
		
		constructor: (name, options = {}) ->
			instance = @constructor.get name ; if instance? then return instance
			
			@name  = name
			@image = Img.get name
			console.log @image
			
			@options = Object.extend _options, options
			Object.extend @, @options
			console.log @size
			
			_instances[name] = @
		
		draw: (g, vTile, vDraw) ->
			g.beginPath()
			g.drawImage @image,
				vTile.i * @size, vTile.j * @size, @size, @size, vDraw.i, vDraw.j, @size, @size
			g.closePath()
