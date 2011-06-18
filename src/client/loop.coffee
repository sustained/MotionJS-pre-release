define [
	'shared/loop'
], (Loop) ->
	class ClientLoop extends Loop
		constructor: (options) ->
			super
			
			Motion.ready =>
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
			super

			@fpsUpdate.html String.pad @updateRate, 3, '&nbsp;'
			@fpsRender.html String.pad @loopRate,   3, '&nbsp;' if not isNaN @loopRate
