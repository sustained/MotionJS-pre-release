define ['core/statemanager'], (StateManager) ->
	class ScreenManager extends StateManager
		focus: false
		autopause: true

		constructor: (game) ->
			super

			jQuery(window).focus =>
				console.log 'window focused'
				@focus = true
				@play() if @autopause is true
			
			jQuery(window).blur =>
				console.log 'window blurred'
				@focus = false
				@pause() if @autopause is true

		sort: ->
			@enabled = @enabled.sort (a, b) =>
				if @states[a].zIndex > @states[b].zIndex then 1 else -1
			
			@
