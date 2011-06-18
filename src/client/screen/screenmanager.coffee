define [
	'shared/statemanager'
], (StateManager) ->
	class ScreenManager extends StateManager
		focus: false
		autopause: true

		constructor: (game) ->
			super
		
		setup: ->
			@game.event.on 'ready', (->
				jQuery(window).focus =>
					@focus = true ; @play() if @autopause is true
				), bind: @

			@game.event.on 'ready', (->
				jQuery(window).blur =>
					@focus = false ; @pause() if @autopause is true
				), bind: @
		
		sort: ->
			return
			@enabled = @enabled.sort (a, b) =>
				if @states[a].zIndex > @states[b].zIndex then 1 else -1
			
			@
