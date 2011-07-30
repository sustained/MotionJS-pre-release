define [
	'client/assets/image'
], (Image) ->
	{extend, isArray, isNumber} = _

	class TileSet
		_options = {
			size: 16
		}
		_instances = {}

		@get: (name) -> _instances[name]

		size:  null
		image: null

		constructor: (name, options = {}) ->
			instance = @constructor.get name ;; if instance? then return instance

			@name  = name
			@image = Image.get name

			@options = extend _options, options
			extend @, @options

			if isArray @size
				@cellsX = Math.round @image.width  / @size[0]
				@cellsY = Math.round @image.height / @size[1]
			else if isNumber @size
				@cellsX = Math.round @image.width  / @size
				@cellsY = Math.round @image.height / @size

			#console.log @image, @image.width, @image.height, @cellsX, @cellsY

			_instances[name] = @

		draw: (g, vTile, vDraw) ->
			g.beginPath()
			g.drawImage @image,
				vTile.i * @size, vTile.j * @size, @size, @size, vDraw.i, vDraw.j, @size, @size
			g.closePath()

		toString: ->
			@image.toString()
