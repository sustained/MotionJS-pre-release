define ->
	class Vector
		constructor: (i, j) ->
			@set i, j
		
		@equal: (a, b) ->
			a.i is b.i and a.j is b.j
		@equals: @equal

		@add: (a, b) ->
			new @ a.i + b.i, a.j + b.j

		@subtract: (a, b) ->
			new @ a.i - b.i, a.j - b.j

		@multiply: (v, n) ->
			new @ v.i * n, v.j * n

		@divide: (v, n) ->
			new @ v.i / n, v.j / n

		@perpendicular: (v) ->
			new @ -v.j, v.i

		@limit: (v, n) ->
			vec = v.clone()
			if vec.length() > n then vec.normalize().multiply n else vec

		@normalize: (v) ->
			vec = v.clone()
			len = v.length()
			if len is 0 then vec else vec.divide len
		
		@invert: (v) ->
			new @ -v.i, -v.j
		
		@distance: (a, b) ->
			a.clone().subtract(b).length()

		@floor: (v) ->
			v.clone().floor()

		@round: (v) ->
			v.clone().round()

		@ceil: (v) ->
			v.clone().ceil()

		@rotate: (v, theta) ->
			v.clone().rotate theta
		
		@projectPoint: (point) ->
			
		
		set: (@i = 0, @j = 0) -> @
		
		copy: (v) ->
			@set v.i, v.j

		clone: ->
			new Vector @i, @j

		debug: ->
			"<Vector : i=#{@i}, j=#{@j}>"

		toString: @::debug

		equals: (v) ->
			Vector.equals @, v

		equal: @::equals

		add: (v) ->
			@i += v.i
			@j += v.j
			@

		subtract: (v) ->
			@i -= v.i
			@j -= v.j
			@
		
		multiply: (n) ->
			@i *= n
			@j *= n
			@
		
		divide: (n) ->
			@i /= n
			@j /= n
			@
		
		transform: (matrix) ->
			@clone().set(
				@i * matrix.a + @j * matrix.c + matrix.tx
				@i * matrix.b + @j * matrix.d + matrix.ty
			)
		
		dot: (v) ->
			(@i * v.i) + (@j * v.j)
		
		perpDot: (v) ->
			(@i * v.j) + (-@j * v.i)
		
		cross: (v) ->
			(@i * v.j) - (@j * v.i)
		
		length: ->
			Math.sqrt @dot @

		lengthSquared: ->
			@dot @

		magnitude: @::length

		angle: ->
			Math.atan2 @j, @i
		
		distance: (v) ->
			Math.sqrt @distanceSquared v

		distanceSquared: (v) ->
			v.clone().subtract(@).lengthSquared()
		
		leftNormal:  -> new Vector  @j, -@i
		rightNormal: -> new Vector -@j,  @i
		
		limit: (n) ->
			if @length() > n then @normalize().multiply n else @

		rotate: (theta) ->
			@i = (@i * Math.cos theta) - (@j * Math.sin theta)
			@j = (@i * Math.sin theta) + (@j * Math.cos theta)
			@

		round: (n) ->
			@i = @i.round()
			@j = @j.round()
			@

		normalize: ->
			length = @length()
			if length < 0.01
				@i = @j = 0
				@
			else
				@divide length

		truncate: (max) ->
			@length = Math.min max, @length()
			@
		
		abs: ->
			@set Math.abs(@i), Math.abs(@j)
		
		inv: ->
			@set -@i, -@j
		invert: @::inv
		
		isZero: ->
			@i is 0 and @j is 0

		isUnit: ->
			@length() is 1

		isNormal: @::isUnit

		draw: (graphics) ->
			graphics.beginPath()
			graphics.moveTo 0, 0
			graphics.lineTo @i, @j
			graphics.closePath()
		
		#extend Vector, ClassUtils.Ext.Accessors
		
		#@set 'length', (value) ->
		#	angle = @angle()
		#	@i = Math.cos(angle) * value
		#	@j = Math.sin(angle) * value
		#	@i = 0 if @i.abs() < 0.00000001
		#	@j = 0 if @j.abs() < 0.00000001
		
		#@set 'angle', (theta) ->
		#	length = @length()
		#	@i = Math.cos(theta) * length
		#	@j = Math.sin(theta) * length
	
	Vector