define [
	'classutils'
], (ClassUtils) ->
	class BaseShape
		area:      0
		perimiter: 0
		
		_scaleX: 1
		_scaleY: 1
		
		_position: null
		_rotation: 0
		
		transform:   null
		transformed: false
		
		fill:   ''
		stroke: ''
		
		isNormal:  ->
		isRegular: ->
		
		constructor: (position = new Vector) ->
			#@transform = Matrix.Identity
			@transform =
				a: 1
				b: 0
				c: 0
				d: 1
				tx: 0
				ty: 0
			
			@position = position
		
		extend BaseShape, ClassUtils.Ext.Accessors
		
		@set 'position', (@_position) ->
			@transform.tx = @_position.i
			@transform.ty = @_position.j
			@transformed  = false
		
		@get 'position', -> @_position
		
		@set 'rotation', (@_rotation) ->
			@transform.rotate Math.degreesToRadians _rotation
			@transformed = false
		
		@get 'rotation', -> @_rotation
		
		@set 'scaleX', (@_scaleX) ->
			@transform.scale @_scaleX, @_scaleY
			@transformed = false
		
		@get 'scaleX', -> @_scaleX
		
		@set 'scaleY', (@_scaleY) ->
			@transform.scale @_scaleX, @_scaleY
			@transformed = false
		
		@get 'scaleY', -> @_scaleY
		
		@set 'x', (x) ->
			@_position.i = @transform.tx = x
			@transformed = false
		
		@set 'y', (y) ->
			@_position.j = @transform.ty = y
			@transformed = false
		
		@get 'x', -> @_position.i
		@get 'y', -> @_position.j
		
		draw: noop
	
	BaseShape