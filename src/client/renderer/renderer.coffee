#
define ->
	class Renderer
		bind: null
		args: null

		renderers: null

		#constructor: (scene, camera, options)
		constructor: (options = {}) ->
			@renderers = []
			@setOptions options

		setOptions: (options = {}) ->
			Object.extend @, Object.extend {bind: null, args: []}, options

		log: (log) ->
			console.log "Renderer: #{log}"

		add: (callback, options = {}) ->
			options = Object.extend {
				bind: options.bind or @bind or null
				args: options.args or @args or null
			}, options

			@renderers.push callback.bind.apply(callback,
				[options.bind or @binding].concat(options.args or []))

		remove: (index) ->
			if @isRenderer index
				@disable index
				@renderers.splice index, 1

		isRenderer: (index) ->
			@renderers[index]?

		isEnabled: (index) ->
			@enabled[index] or false

		isDisabled: ->
			not @isEnabled()

		enable: (index) ->
			if @isDisabled index
				@log "enabling callback #{index}"
				@enabled.push index

		disable: (index) ->
			if @isEnabled index
				@log "disabling callback #{index}"
				@enabled.splice index, 1

		render: ->
			i.apply false for i in @renderers
			return
