define [
	'shared/state/state'
], (State) ->
	class Screen extends State
		_zIndex = 0

		zIndex: 0

		transitionIn:  null
		transitionOut: null
		
		constructor: ->
			super
			@zIndex = ++_zIndex

		toTop: ->
			high = 0
			@manager.forEach (state, name) =>
				if name isnt @name
					high = state.zIndex if state.zIndex > high
			return if @zIndex > high
			@zIndex = high + 1
			@el.css 'z-index', @zIndex
		
		toBottom: ->
			low = 0
			@manager.forEach (state, name) =>
				if name isnt @name
					low = state.zIndex if state.zIndex < high
				return if @zIndex < low
			@zIndex = low - 1
			@el.css 'z-index', @zIndex
			#index = @manager.enabled.indexOf(@name)
			#return false if index is -1
			#console.log @manager.enabled.unshift @manager.enabled.splice(index, 1)[0]

