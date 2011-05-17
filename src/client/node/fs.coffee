define ->
	{
		readFile: (path, callback) ->
			jQuery.ajax url: path, type: 'GET', success: callback
		
		readFileSync: (path) ->
			jQuery.ajax(url: path, type: 'GET', async: false).responseText
	}
