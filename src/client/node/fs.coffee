define ->
	{
		getSize: (path, callback = ->) ->
			jQuery.ajax url: path, type: 'HEAD', success: (data, status, jqxhr) ->
				callback.call null, jqxhr.getResponseHeader 'Content-Length'
		
		getSizeSync: (path) ->
			jQuery.ajax(url: path, type: 'HEAD', async: false).getResponseHeader 'Content-Length'
		
		readFile: (path, callback) ->
			jQuery.ajax url: path, type: 'GET', success: callback
		
		readFileSync: (path) ->
			jQuery.ajax(url: path, type: 'GET', async: false).responseText
	}
