#
define [
	'client/assets/image'
	'client/graphics/tileset'
], (Img, TileSet) ->
	{Vector} = Math

	class Sprite
		_instances = {} ; @get: (name) -> _instances[name]

		draw:  null # HTMLImageElement
		image: null # Motion Image Object

		size:     null
		position: null

		width:  0
		height: 0

		constructor: (@name, image, size = []) ->
			instance = @constructor.get name ; if instance? then return instance

			if image.constructor.name is 'TileSet'
				@image = image.image
			else
				@image = image

			@draw = @image.domOb

			@width  = size[0] ? @image.width
			@height = size[1] ? @image.height

			@position = new Vector

			_instances[name] = @

		update: ->


		render: (g, draw) ->
			g.beginPath()
			g.drawImage @draw, @position.i, @position.j, @width, @height, draw[0], draw[1], @width, @height
			g.closePath()

	class AnimatedSprite extends Sprite
		constructor: ->
			super

	Sprite
