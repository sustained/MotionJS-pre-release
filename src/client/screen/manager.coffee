define [
	'shared/state/manager'
], (StateManager) ->
	class ScreenManager extends StateManager
		focus: false
		autopause: true

		constructor: ->
			super

		setup: ->
			win = jQuery window
			jQuery =>
				win.blur  => @focus = false ; @pause() if @autopause is true
				win.focus => @focus = true  ; @play()  if @autopause is true

		sort: ->
			return
			@enabled = @enabled.sort (a, b) =>
				if @states[a].zIndex > @states[b].zIndex then 1 else -1

			@
