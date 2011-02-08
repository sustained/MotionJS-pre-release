define ['motion'], ->
	class AssetManager
		@build: (url, ext) ->
			if url.lastIndexOf '.' is -1
				url += '.' + ext
			if name.indexOf '://' is -1
				url = @base + url
		
			[url, ext]
	
		base:  null
		async: true
		cache: false
	
		group:  'default'
		groups: null
	
		constructor: ->
			@groups = {}
	
		createGroup: (name) ->
			return false if @isGroup name
			@groups[name] = {}
	
		activeGroup: (name = 'default') ->
			@group = name
	
		removeGroup: (name) ->
			return false if name is 'default'
			delete @groups[name] if @isGroup name
			true
	
		isGroup: (name) ->
			name of @groups
	
		load: ->
	
	AssetManager