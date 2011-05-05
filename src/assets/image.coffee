define [
	'assets/asset'
	'assets/batch'
], (Asset, Batch) ->
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
			return false if @status is Image.STATUS.LOADED or @status is Image.STATUS.ERROR # or not Motion.DOM_READY
			
			@asset = jQuery '<img>'
			@domOb = @asset[0]
			
			@asset.load =>
				console.log "Load Image (success): #{@basename()}.#{@extname()}"
				@asset.appendTo 'body'
				
				@status = Image.STATUS.LOADED
				@width  = @domOb.width
				@height = @domOb.height
				
				if @batch isnt null then @batch.event.fire 'load', [@]
			
			@asset.error =>
				console.log "Load Image (failure): #{@name}.#{@extname()}"
				
				@status = Image.STATUS.ERROR
			
			@asset.css  'display', 'none'
			@asset.attr 'src', Image.getUrl() + @path + '.' + @extname()
	
	Image.Batch = class ImageBatch extends Batch
		constructor: (batch, options = {}) ->
			super batch, Object.extend options, load: Image
	
	Image
