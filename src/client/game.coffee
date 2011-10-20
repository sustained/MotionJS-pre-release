#
define [
	'path'

	'client/loop'

	'client/assets/asset'
	'client/assets/batch'
	'client/assets/image'
	#'client/assets/audio'
	#'client/assets/video'

	'client/input/keyboard'
	'client/input/mouse'

	'client/screen/manager'

	'game'

	#'world/tiled'
	#'world/rigid'
], (path, Loop, Asset, Batch, Image, Keyboard, Mouse, ScreenManager, SharedGame) ->
	class ClientGame extends SharedGame
		@DEFAULT_OPTIONS: {
			delta: 1.0 / 60
			display:
				size:  [1024, 768]
				scale: 1.0
			preload: {}
		}

		#console.log 'ClientGame instance = null'
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

			console.log config.url

			config = Object.merge ClientGame.DEFAULT_OPTIONS, config
			@loop  = new Loop delta: config.delta

			super

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

			#setTimeout (->
			@state = new ScreenManager
			@state.setup()
			#), 1
