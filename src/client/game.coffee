define [
	'assets/asset'
	'assets/batch'
	'assets/image'
	#'assets/audio'
	#'assets/video'

	'graphics/canvas'
	'graphics/tileset'

	'client/input/keyboard'
	'client/input/mouse'

	'shared/game'

	#'world/tiled'
	#'world/rigid'
], (Asset, Batch, Image, Canvas, TileSet, Keyboard, Mouse, Game) ->
	{Class, Eventful} = Motion

	class ClientGame extends Game
		@DEFAULT_OPTIONS = {
			delta: 1.0 / 60
			display:
				size:  [1024, 768]
				scale: 1.0
			preload:
				audio: null
				image: null
				video: null
			states:   null
			entities: null
		}

		_instance = null
		@instance: -> return if _instance then _instance else new @

		constructor: (url, config = {}) ->
			return _instance if _instance?

			super url, Object.merge ClientGame.DEFAULT_OPTIONS, config

			# if not a touch device...
			@mouse    = new Mouse
			@keyboard = new Keyboard

			@canvas = new Canvas @config.display.size

			if url
				Asset.setUrl url + 'assets/'
				Image.setUrl 'image/naughty/', true
				#Audio.setUrl null, true
				#Video.setUrl null, true

			_instance = @
