define [
	'utilities/eventful'
], (Eventful) ->
	class Batch
		@LOAD:
			QUEUE: 1 # Wait for each asset to load before loading the next
			MULTI: 2 # Load all of the assets simultaneously
		
		_defaultOptions =
			load: Batch.LOAD.QUEUE
		
		_onLoad = (asset) ->
			@isLoad++ ; @toLoad--
			
			if @toLoad is 0
				@event.fire 'loaded'
			else
				if Batch.TYPE is Batch.LOAD.QUEUE then @queue[@toLoad - 1].load()
		
		_onLoaded = ->
			@_loaded = true
			console.log "Asset Batch: Loaded #{@queue.length} assets"
			console.log @queue
		
		event: null
		queue: null
		
		_load:   null
		_asset:  null
		_loaded: false
		
		constructor: (batch, asset, options = {}) ->
			if not Function.isConstructor asset
				throw 'Batch constructor - need "asset" parameter'
				return
			
			options = Object.extend _defaultOptions, options
			
			@event  = new Eventful ['load', 'loaded'], binding: @
			@queue  = []
			@_load  = options.load
			@_asset = asset
			
			if Object.isObject batch
				for name, path of batch
					@queue.push new @_asset name, path, batch: @
			else
				# read everything from the directory
			
			@toLoad = @queue.length
			@isLoad = 0
			
			@event.on 'load',   _onLoad.bind   @
			@event.on 'loaded', _onLoaded.bind @
		
		load: ->
			return false if @_loaded is true
			
			if @queue.length > 0
				if @type is Batch.LOAD.QUEUE
					@queue[@toLoad - 1].load()
				else
					asset.load() for asset in @queue
				
				return true
			
			return null
		
		isLoaded: ->
			@_loaded is true
