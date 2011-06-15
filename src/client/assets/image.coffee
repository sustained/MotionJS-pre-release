define [
	'client/assets/asset'
], (Asset) ->
	class Image extends Asset
		@STATUS:
			NONE:    0 # Not loaded yet
			ERROR:   1 # Error loading
			LOADING: 2 # Currently loading
			LOADED:  3 # Finished loading
		
		@DEFAULT_EXTENSION: 'png'
		
		@Batch: null
		
		@_url: null
		
		@setUrl: (url = 'image/', asset = false) ->
			@_url = if asset is true then Asset.getUrl() + url else url
		
		@getUrl: -> @_url
		
		_instances = {} ; @get: (name) -> _instances[name]
		
		image:  null
		status: null
		
		ext:  null
		name: null
		
		width:  0
		height: 0
		
		toString: -> @constructor.getUrl() + @path + '.' + @extname()
		
		constructor: (name, path, options = {}) ->
			instance = @constructor.get name ; if instance? then return instance
			
			super name, path
			
			@batch  = options.batch ? null
			@status = Image.STATUS.NONE
			
			#console.log "Create Image: #{@basename()}.#{@extname()}"
			
			if Image.AUTOLOAD is true and Motion.env is 'client'
				Motion.event.on 'dom', => @load()
			
			_instances[name] = @
		
		load: ->
			if @status is Image.STATUS.LOADED or @status is Image.STATUS.ERROR
				return false
			
			@asset = jQuery '<img>'
			@domOb = @asset[0]				

			loadAsset = =>
				@log "load success"
				
				@status = Image.STATUS.LOADED
				@width  = @domOb.width
				@height = @domOb.height
				
				if @batch isnt null
					@batch.event.fire 'load', [@]
			
			@asset.css  'display', 'none'
			@asset.attr 'src', Image.getUrl() + @path + '.' + @extname()
			@asset.appendTo 'body'

			if @domOb.complete is true
				@log 'image is cached'
				loadAsset()
			else
				@log 'image not cached'
				@asset.load loadAsset
				@asset.error =>
					@log "load failure"
					@status = Image.STATUS.ERROR
				
	
	###Image.Batch = class ImageBatch extends Batch
		constructor: (batch, options = {}) ->
			super batch, Object.extend options, load: Image###
	
	Image
