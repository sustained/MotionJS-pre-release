define ->
	###
		BaseClass for Image, Audio, Video
	###
	class Asset
		@STATUS:
			NONE: 0
		
		@_url = null
		
		@setUrl: (url) -> @_url = url
		@getUrl:       -> @_url
		
		name:   null
		asset:  null
		status: null
		
		_extname:  null
		_basename: null
		
		extname:  -> @_extname
		basename: -> @_basename
			
		constructor: (@name, path = '') ->
			@path   = path
			@status = Asset.STATUS.NONE
			
			dot   = @path.lastIndexOf '.'
			slash = @path.lastIndexOf '/'
			
			if dot > -1
				@_extname = path.substr dot ; path = path.slice dot
			else
				@_extname = @constructor.DEFAULT_EXTENSION
			
			if slash > -1
				@_basename = path.substr slash + 1
			else
				@_basename = path
		
		toString: ->
			@basename() + '.' + @extname()
		
		load: -> null
