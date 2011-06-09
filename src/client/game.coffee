define [
	'client/assets/asset'
	'client/assets/batch'
	'client/assets/image'
	#'client/assets/audio'
	#'client/assets/video'

	'path'

	'client/input/keyboard'
	'client/input/mouse'

	'shared/game'

	'client/screen/screenmanager'

	#'world/tiled'
	#'world/rigid'
], (Asset, Batch, Image, path, Keyboard, Mouse, SGame, ScreenManager) ->
	{Class, Eventful} = Motion

	class ClientGame extends SGame
		@DEFAULT_OPTIONS: {
			delta: 1.0 / 60
			display:
				size:  [1024, 768]
				scale: 1.0
			preload: {}
		}

		_instance = null
		@instance: -> return if _instance then _instance else new @

		constructor: (config = {}) ->
			return _instance if _instance?

			if config.url?
				url = config.url
				url = url.replace /^http[s]?\:\/\//, ''
				url = path.normalize url
				url = if url.substr(4, 1) is 's' then "https://#{url}" else "http://#{url}"
				config.url = url
			
			@state = new ScreenManager @
			super Object.merge ClientGame.DEFAULT_OPTIONS, config
			@state.setup()
			
			# if touch device
			# @touch = new Touchpad
			# else
			@mouse    = new Mouse
			@keyboard = new Keyboard

			if url
				Asset.setUrl url + 'assets/'
				Image.setUrl 'image/naughty/', true
				#Audio.setUrl null, true
				#Video.setUrl null, true

			_instance = @
