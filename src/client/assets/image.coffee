define [
	'client/assets/asset'
], (Asset) ->
	{Event} = Motion

	class Image extends Asset
		@event = new Event()

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

		_instances = {}

		@get: (name) -> _instances[name]

		image:  null
		status: null

		ext:  null
		name: null

		width:  0
		height: 0

		toString: ->
			@constructor.getUrl() + @path + '.' + @extname()

		isLoaded: ->
			@status is Image.STATUS.LOADED

		constructor: (name, path, options = {}) ->
			instance = Image.get name
			return instance if instance

			super name, path

			@batch  = options.batch ? null
			@status = Image.STATUS.NONE
			if not @batch?
				Image.event.add "load:#{name}" #, once: true

			#console.log "Create Image: #{@basename()}.#{@extname()}"

			if Image.AUTOLOAD is true and Motion.env is 'client'
				jQuery => @load()

			_instances[name] = @
		
		loaded: (fn = ->) ->
			@_loaded = fn.bind @

		load: ->
			if @status is Image.STATUS.LOADED or @status is Image.STATUS.ERROR
				return false

			@asset = jQuery('<img>')
				.attr('src', Image.getUrl() + @path + '.' + @extname())
				.appendTo 'body'
			@domOb = @asset[0]

			loadAsset = =>
				@log "load success"
				@width  = @domOb.width
				@height = @domOb.height
				@status = Image.STATUS.LOADED
				if @batch isnt null
					@batch.event.fire 'load', [@]
				else
					Image.event.fire "load:#{@name}"
				@asset.css 'display', 'none'

			#console.log @asset
			if @domOb.complete is true
				@log 'image is cached'
				loadAsset()
			else
				@log 'image not cached'
				@asset.load loadAsset
				@asset.error =>
					@log "load failure"
					@status = Image.STATUS.ERROR
			@

	###Image.Batch = class ImageBatch extends Batch
		constructor: (batch, options = {}) ->
			super batch, extend options, load: Image###

	Image
