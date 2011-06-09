define ->
	class Eventful
		binding: null
		runOnce: null
		aliases: false
		
		events: null
		group:  'default'
		
		constructor: (events, options = {}) ->
			if events? and not Array.isArray events
				events  = Array::slice.call arguments
				options = if Object.isObject events[events.length - 1]
					events.pop()
				else
					{}
			
			@aliases = options.aliases ? false
			@binding = options.binding ? null
			
			@events       = {} # name: [callbacks]
			@eventNames   = []
			@eventOptions = {} # event specific options
			
			@add events
		
		###
		hashKey: (key) ->

		createGroup: (name, enable = false) ->
			name = name.hash() if not isString name and 'hash' of name
			
			if not @isGroup name
				@groups[name] = enable
				@groupNames.push name
		
		openGroup: (name) ->
			name = name.hash() if not isString name and 'hash' of name
		
		closeGroup: ->
			@group = 'default'
			@
		
		enableGroup: (name) ->
			@groups[name] = on if @isGroup name
		
		disableGroup: (name) ->
			return false if name is 'default'
			@groups[name] = off if @isGroup name
		
		isGroup: (name) ->
			@groups.hasOwnProperty name
			###

		isEvent: (name) ->
			@eventNames.indexOf(name) > -1

		after: (name, callback, options) ->
			return false if not @isEvent(name) or @eventOptions[name].limit is false
			@on "after_#{name}", callback, options
		
		on: (name, callback, options = {}) ->
			@add name if not @isEvent name
			
			return false if not Function.isFunction callback
			
			callback = callback.bind.apply(callback,
				[options.bind or @binding].concat(options.args or []))

			@events[name].push [callback, {once: options.once or false}]
			#group: @group}]
			###call:  callback.bind.apply callback, [options.bind ? @binding, options.args ? []]
			#args:  options.args ? []
			#bind:  options.bind ? @binding
			once:  options.once ? @runOnce
			#when:  options.when ? true
			group: @group###
			
			@
		
		###
			Create an event
		###
		add: (name, options = {}) ->
			if Array.isArray(name)
				@add i for i in name
			else if name?
				if not @isEvent(name)
					@events[name]       = []
					@eventOptions[name] = {}

					@eventNames.push name
					@setOptions name, options
			@
		
		setOptions: (name, options = {}) ->
			if @isEvent(name)
				opts = @eventOptions[name] = Object.extend {
					limit: false
				}, options
				
				if opts.limit isnt false and opts.limit > 0 and not opts.count?
					opts.count = 0
					@add "after_#{name}"
		
		createAliases: (name) ->
			alias = String.capital(name.replace /_/g, ' ').replace /\s/g, ''
			
			@['on' + alias] = (callback, options) ->
				@on name, callback, options
			
			@['fire' + alias] = (args) ->
				@fire name, args
			
			@['clear' + alias] = (remove) ->
				@clear name, remove
			
			@['remove' + alias] = () ->
				@remove name
		
		deleteAliases: (name) ->
			alias = name.capitalize().replace '_', ''
			delete @['on'     + alias]
			delete @['fire'   + alias]
			delete @['clear'  + alias]
			delete @['remove' + alias]
		
		remove: (name) ->
			if @isEvent name
				@clear name, true
				
				@deleteAliases name if @aliases is on
		
		fire: (name, args = []) ->
			#return console.log "non-existant event #{name}" if not @isEvent name
			return false if not @isEvent(name)
			
			removes = []
			
			for i in @events[name]
				call  = i[0]
				opts  = i[1]

				call.apply false, args
				
				if opts.once is true
					removes.push _i
			
			if removes.length > 0
				@removeCallback name, remove for remove in removes
			
			opts = @eventOptions[name]
			if opts.limit isnt false
				#console.log "#{opts.count + 1} / #{opts.limit}"
				if ++opts.count is opts.limit
					@fire "after_#{name}"
					@clear name, true
					@clear "after_#{name}", true
			
			return true
		
		clear: (name, remove = false) ->
			if @isEvent(name)
				if remove is true
					delete @events[name]
					delete @eventOptions[name]
					@eventNames.splice @eventNames.indexOf(name), 1
				else
					@events[name] = []
		
		removeCallback: (name, index) ->
			if @isEvent(name) and index >= 0 and index < @events[name].length
				@events[name].splice index, 1