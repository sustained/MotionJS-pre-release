define ->
	class Eventful
		@TEST: 'ing'
		
		binding: null
		runOnce: null
		aliases: false
	
		group: 'default'
	
		constructor: (events, options = {}) ->
			if events? and not Array.isArray events
				events  = Array::slice.call arguments
				options = if Object.isObject events[events.length - 1]
					events.pop()
				else
					{}
			
			@aliases = options.binding ? false
			@binding = options.binding ? null
			
			@events = {}
			@groups = default: true
			
			@eventNames = []
			@groupNames = []
		
			@add events if Array.isArray events
	
		createGroup: (name, enable = false) ->
			name = name.hash() if not isString name and 'hash' of name
		
			if not @isGroup name
				@groups[name] = enable
				@groupNames.push name
	
		isEvent: (name) ->
			@events.hasOwnProperty name
	
		hashKey: (key) ->
		
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
	
		on: (name, callback, options = {}) ->
			@add name if not @isEvent name
		
			return false if not Function.isFunction callback
		
			@events[name].push
				call:  callback
				args:  options.args ? []
				bind:  options.bind ? @binding
				once:  options.once ? @runOnce
				when:  options.when ? true
				group: @group
		
			@
	
		add: (name, createAliases = off) ->
			if Array.isArray name
				@add i for i in name
			else if name?
				return false if @isEvent name
			
				@events[name] = []
				@eventNames.push name
			
				@createAliases name if @aliases or createAliases is on
			@
	
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
			return false if not @isEvent name
		
			for callback in @events[name]
				continue if @groups[callback.group] is false
			
				callback.call.apply callback.bind, callback.args.concat args
			
				@removeCallback name, _i if callback.once is on
	
		clear: (name, remove = no) ->
			if @isEvent name
				@events[name] = []
			
				delete @events[name] if remove is yes
	
		removeCallback: (name, id) ->
			@events[name].splice id, 1 if @isEvent name and @events[name][id]
