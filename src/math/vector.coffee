define ->
	class Vector
		constructor: (i, j) ->
			if isArray i
				@set i[0], i[1]
			else
				@set i, j

		@Array: (n, v = new @) ->
			i = 0
			v while i < n
				
		@add: (a, b) ->
			new @ a.i + b.i, a.j + b.j

		@subtract: (a, b) ->
			new @ a.i - b.i, a.j - b.j

		@multiply: (v, n) ->
			new @ v.i * n, v.j * n

		@divide: (v, n) ->
			new @ v.i / n, v.j / n

		@normalize: (v) ->
			v = v.clone()
			l = v.length()
			return if l is 0 then v.set(0.00000001, 0.00000001) else v.divide l

		@limit: (v, n) ->
			v = v.clone()
			l = v.length()
			return if l > n then v.normalize().multiply n else v
		
		@lerp: (a, b, t) ->
			Vector.add a, Vector.subtract(b, a).multiply(t)
		
		@invert: (v) ->
			v.clone().invert()

		@angle: () ->
			dot = @dot

		@rotate: (v, theta) ->
			v.clone().rotate theta

		@abs: (v) ->
			v.clone().abs()

		@floor: (v) ->
			v.clone().floor()

		@round: (v) ->
			v.clone().round()

		@ceil: (v) ->
			v.clone().ceil()

		leftNormal: (v) ->
			new @ v.j, -v.i

		rightNormal: (v) ->
			new @ -v.j, v.i

		perpendicular: (v) ->
			new @ -v.j, v.i

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

		normalize: ->
			l = @length()
			return if l is 0 then @ else @divide l

		limit: (n) ->
			if @length() > n then @normalize().multiply n else @

		array: ->
			[@i, @j]
		
		invert: ->
			@set -@i, -@j

		rotate: (theta) ->
			@i = (@i * Math.cos theta) - (@j * Math.sin theta)
			@j = (@i * Math.sin theta) + (@j * Math.cos theta)
			@

		abs: ->
			@set Math.abs(@i), Math.abs(@j)

		floor: ->
			@set Math.floor(@i), Math.floor(@j)

		round: ->
			@set Math.round(@i), Math.round(@j)

		ceil: (v) ->
			@set Math.ceil(@i), Math.ceil(@j)

		transform: (matrix) ->
			@clone().set(
				@i * matrix.a + @j * matrix.c + matrix.tx
				@i * matrix.b + @j * matrix.d + matrix.ty
			)

		# these shouldn't really be here
		leftNormal:  -> new Vector  @j, -@i
		rightNormal: -> new Vector -@j,  @i

		length: ->
			Math.sqrt @dot @

		lengthSquared: ->
			@dot @

		distance: (v) ->
			Math.sqrt @distanceSquared v

		distanceSquared: (v) ->
			v.clone().subtract(@).lengthSquared()

		dot: (v) ->
			(@i * v.i) + (@j * v.j)

		perpDot: (v) ->
			(@i * v.j) + (-@j * v.i)

		cross: (v) ->
			(@i * v.j) - (@j * v.i)

		angle: ->
			Math.atan2 @j, @i

		@::equal = @::equals = (v) ->
			Vector.equals @, v

		isZero: ->
			@i is 0 and @j is 0

		isUnit: ->
			@length() is 1

		isNormal: @::isUnit

		###
		
		###

		set: (@i = 0, @j = 0) ->
			@

		copy: (v) ->
			@set v.i, v.j

		clone: ->
			new Vector @i, @j

		@::debug = @::toString = ->
			"Vector:(#{@i},#{@j})"

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
	
	Vector.__defineGetter__ 'Zero', -> new Vector
	Vector.__defineGetter__ 'Rand', -> new Vector Math.random() * Number.MAX_VALUE, Math.random() * Number.MAX_VALUE
	
	Vector