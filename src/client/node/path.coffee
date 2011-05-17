define ->
	{
		normalize: (path) ->
		
		join: ->
		
		resolve: ->
		
		dirname: (path) ->
		
		basename: (path, ext) ->
		
		extname: (path) ->
			dot = path.indexOf('.')
			return if dot > -1 then path.substr dot + 1 else ''
		
		exists: (path, callback) ->
			jQuery.ajax url: path, type: 'HEAD', success: callback
		
		existsSync: (path) ->
			jQuery.ajax(url: path, type: 'HEAD', async: false).status is 200
	}
