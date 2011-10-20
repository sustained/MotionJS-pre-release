define [
	'loop'
], (Loop) ->
	{pad} = Motion.Utils.String

	class ClientLoop extends Loop
		constructor: (options) ->
			super

			jQuery =>
				updateEl = jQuery '<p>Update @ <span>  0</span> FPS</p>'
				renderEl = jQuery '<p>Render @ <span>  0</span> FPS</p>'

				@fpsContainer = jQuery('<div />').attr 'id', 'motionFpsContainer'
				@fpsUpdate    = jQuery 'span', updateEl
				@fpsRender    = jQuery 'span', renderEl

				updateEl.add(renderEl).appendTo @fpsContainer.appendTo 'body'

		stop: ->
			super
			@fpsUpdate.html '&nbsp;&nbsp;0'
			@fpsRender.html '&nbsp;&nbsp;0'

		pause: @::stop

		showFps: ->
			@fpsContainer.show()

		hideFps: ->
			@fpsContainer.hide()

		frameRate: ->
			#super

			@fpsUpdate.html pad @updateRate.toFixed(0), 3, '&nbsp;'
			@fpsRender.html pad @loopRate.toFixed(0), 3, '&nbsp;' if not isNaN @loopRate
