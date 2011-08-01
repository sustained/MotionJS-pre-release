define [
	'shared/state/manager'
], (StateManager) ->
	class ScreenManager extends StateManager
		autoPause: false

		_focus: false
		zIndex: null
		
		constructor: ->
			super

			@zIndex =
				low:  0
				high: 0
				curr: 0
			
			@setup()
		
		###
		add: (name, klass, options = {}) ->
			super name, klass, options

			@zIndex.high = ++@zIndex.curr
			added = @$ name
			added.zIndex = @zIndex.curr
		###
		setup: ->
			$w = jQuery window
			jQuery =>
				$w.blur  =>
					@_focus = false
					@pause() if @autoPause is true
				$w.focus =>
					@_focus = true
					@play() if @autoPause is true

		sort: ->
			@enabled = @enabled.sort (a, b) =>
				if @states[a].zIndex > @states[b].zIndex then 1 else -1

			@
