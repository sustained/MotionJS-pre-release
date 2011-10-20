#
define [
	'client/screen/screen'
	'client/assets/batch'
], (Screen, Batch) ->
	{Vector} = Math
	{merge, isObject} = Motion.Utils.Object

	class Loader extends Screen
		@defaults = {
			width: 1024 / 4
			height: 768 / 8
			toLoad: 0
			loading: 'assets'
		}

		assets: null

		constructor: ->
			super

			@bar =
				w: 1024 / 4
				h:  768 / 8
			@bar.x = (1024 / 2) - (@bar.w / 2)
			@bar.y = ( 768 / 2) - (@bar.h / 2)

			jQuery =>
				@_loadText = jQuery('<p>Loading <span></span> of <span></span> <span></span></p>')
					.css(
						display: 'block', width: '1024px', height: '768px', 'line-height': '768px'
						position: 'absolute', top: 0, left: 0, 'z-index': 1000
						color: 'white', 'font-size': '10px', 'text-align': 'center'
					)
					.hide()
					.appendTo('body')

				spans = jQuery 'span', @_loadText
				@textLoaded  = spans.eq 0
				@textToLoad  = spans.eq 1
				@textLoading = spans.eq 2

			@batch = new Batch()

			#@setAssets @assets if isObject @assets

		setAssets: (assets = {}) ->
			@batch.add(assets.image, 'image')
			#@batch.add @assets.audio, 'audio' if isObject @assets.audio
			#@batch.add @assets.video, 'video' if isObject @assets.video
			@batch.event.on 'load', =>
				@textLoaded.text @batch.isLoad

			@batch.event.on 'loaded', =>
				@loaded()

			@magicNumber = @bar.w / @batch.toLoad
			@textLoaded.text  @batch.isLoad
			@textToLoad.text  @batch.toLoad
			@textLoading.text "images"

		focus: ->
			@_loadText.show()

		blur: ->
			@_loadText.hide()

		load: ->
			@batch.load()

		loaded: ->

		update: (delta) ->
			@manager.loop.fps()

		render: (g) ->
			g.clearRect 0, 0, 1024, 768

			g.lineWidth = 2

			g.beginPath()
			g.strokeStyle = '#101010'
			g.strokeRect @bar.x, @bar.y, @bar.w, @bar.h
			g.closePath()

			percentWidth = Math.round @magicNumber * @batch.isLoad

			g.beginPath()
			g.fillStyle = '#202020'
			g.fillRect @bar.x, @bar.y, percentWidth, @bar.h
			g.closePath()

			g.lineWidth = 1
