define [
	'shared/game'
], (Game) ->
	class ServerGame extends Game
		@DEFAULT_OPTIONS: {
			delta: 1.0 / 30
		}

		_instance = null
		@instance: -> return if _instance then _instance else new @

		constructor: (config = {}) ->
			return _instance if _instance?
			
			super Object.merge ServerGame.DEFAULT_OPTIONS, config
			
			_instance = @
