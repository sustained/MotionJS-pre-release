define ->
	class Eventful
		binding: null
		runOnce: null
		aliases: no
	
		group: 'default'
	
		constructor: (events, options = {}) ->
			if events? and not isArray events
				events  = Array::slice.call arguments
				options = if isObject events.last() then events.pop() else {}
		
			@binding = options.binding ? null
		
			@events = {}
			@groups = default: true
		
			@eventNames = []
			@groupNames = []
		
			@add events if isArray events
	
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
		
			return false if not isFunction callback
		
			@events[name].push
				call:  callback
				args:  options.args ? []
				bind:  options.bind ? @binding
				once:  options.once ? @runOnce
				when:  options.when ? true
				group: @group
		
			@
	
		add: (name, createAliases = off) ->
			if isArray name
				@add i for i in name
			else if name?
				return false if @isEvent name
			
				@events[name] = []
				@eventNames.push name
			
				@createAliases name if @aliases or createAliases is on
			@
	
		createAliases: (name) ->
			alias = name.replace(/_/g, ' ').capitalize().replace /\s/g, ''
		
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
