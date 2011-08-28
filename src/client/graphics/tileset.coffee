define [
	'client/assets/image'
], (Image) ->
	{extend, isArray, isNumber} = _
	{clone} = Motion.Utils.Object

	class TileSet
		_defaults =
			size: [16, 16]

		_instances = {}

		@get: (name) ->
			_instances[name]

		@del: (name) ->
			if name of _instances
				# TODO: clean up (remove the image... etc.?)
				_instances[name] = null
				return true
			return false
		
		cellsX: null
		cellsY: null

		size:  null
		image: null

		constructor: (name, opts) ->
			instance = TileSet.get name
			if instance? then return instance

			@name = name
			@size = (opts or _defaults).size
			@size = [@size, @size] if isNumber @size
			@image = Image.get name

			countCells = =>
				@cellsX = Math.round @image.width / @size[0]
				@cellsY = Math.round @image.height / @size[1]

			if @image?
				if @image.isLoaded()
					countCells()
				else
					#@image.event.on 'loaded', countCells
			else
				@cellsX = @cellsY = -1

			_instances[name] = @

		###draw: (g, vTile, vDraw) ->
			g.beginPath()
			g.drawImage @image,
				vTile.i * @size[0], vTile.j * @size[1], @size[0], @size[1]
				vDraw.i, vDraw.j, @size[0], @size[1]
			g.closePath()###

		toString: ->
			@image.toString()
