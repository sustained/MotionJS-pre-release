define [
	'client/renderer/renderer'

	'graphics/canvas'
], (Renderer, Canvas) ->
	class CanvasRenderer extends Renderer
		canvas:  null
		context: null

		constructor: (canvas, options = {}) ->
			if Object.isObject canvas
				options = canvas
			else
				@setCanvas canvas

			super options
		
		setCanvas: (canvas) ->
			@canvas  = canvas
			@context = canvas?.context
			@args    = [@context] if @context
