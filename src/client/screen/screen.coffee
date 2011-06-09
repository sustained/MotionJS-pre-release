define [
	'shared/state'
], (State) ->
	class Screen extends State
		_zIndex = 0

		zIndex: 0

		transitionIn:  null
		transitionOut: null

		constructor: (name, game) ->
			super

			@zIndex = ++_zIndex
