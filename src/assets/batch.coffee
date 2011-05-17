define [
	'assets/audio'
	'assets/image'
	'assets/video'
], (Audio, Image, Video) ->
	{Eventful} = Motion
	
	class Batch
		@LOAD:
			QUEUE: 1 # Wait for each asset to load before loading the next
			MULTI: 2 # Load all of the assets simultaneously
		
		_defaultOptions =
			load: Batch.LOAD.QUEUE
			type: null
		
		_onLoad = (asset) ->
			@isLoad++ ; @toLoad--
			
			if @toLoad is 0
				@event.fire 'loaded'
			else
				if Batch.TYPE is Batch.LOAD.QUEUE then @queue[@toLoad - 1].load()
		
		_onLoaded = ->
			@_loaded = true
			console.log "Asset Batch: Loaded #{@length} assets"
		
		event:  null
		queue:  null
		length: null
		toLoad: null
		isLoad: null
		
		_load:   null
		_type:   null
		_loaded: false
		
		constructor: (batch, options = {}) ->
			options = Object.extend _defaultOptions, options
			
			@queue = []
			@_load = options.load
			@_type = options.type
			
			@length = 0
			@toLoad = 0
			@isLoad = 0
			
			@add batch if batch
			
			@event = new Eventful ['load', 'loaded'], binding: @
			@event.on 'load',   _onLoad.bind @
			@event.on 'loaded', _onLoaded.bind @
		
		_assetMap = {
			audio: Audio
			image: Image
			video: Video
		}
		
		add: (name, path, asset = null) ->
			if String.isString name
				batch = {name: path}
			else if Object.isObject name
				batch = name
				asset = path
				name  = null
				path  = null
			
			if asset is null
				if @_type is null then throw 'asset type?' ;; return
				asset = @_type
			
			if not _assetMap[asset]?
				throw "unknown asset type #{asset}" ;; return
			
			asset = _assetMap[asset]
			
			for name, path of batch
				@length++ ;; @toLoad++
				@queue.push new asset name, path, batch: @
			
			return true
		
		load: ->
			return false if @_loaded is true
			
			if @queue.length > 0
				if @_type is Batch.LOAD.QUEUE
					@queue[@toLoad - 1].load()
				else
					asset.load() for asset in @queue
				
				return true
			
			return null
		
		isLoaded: ->
			@_loaded is true
