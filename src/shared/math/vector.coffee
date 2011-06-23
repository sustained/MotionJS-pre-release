define ->
	class Vector
		set: (@i = 0, @j = 0) ->
			@
		
		constructor: (i, j) ->
			if i and i.length
				@set i[0], i[1]
			else
				@set i, j
		
		@up:    new @( 0, -1)
		@down:  new @( 0,  1)
		@left:  new @(-1,  0)
		@right: new @( 1,  0)
		
		@zero: new @(0, 0)
		
		# todo - remove
		@__defineGetter__ 'Zero', ->
			new Vector
		
		max = Number.MAX_VALUE
		# todo - remove
		@__defineGetter__ 'Rand', ->
			new Vector Math.random() * max, Math.random() * max
		
		@isVector: (object) -> object? and object.constructor.name is 'Vector'
		
		@random: ->
			new Vector Math.random() * max, Math.random() * max
		
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
		
		@lerp: (start, change, t) ->
			Vector.add start, Vector.multiply(change, t)
			#new Vector(
			#	Math.lerp(start.i, change.i, t),
			#	Math.lerp(start.j, change.j, t)
			#)
		
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
		
		sigh: (v) ->
			dot  = @dot v
			modA = @length()
			modB = v.length()
			
			return null if modA * modB is 0
			
			return Math.acos Math.clamp dot / (modA * modB), -1, 1
		
		###
		angleFrom: function(vector) {
	    	var V = vector.elements || vector;
	    	var n = this.elements.length, k = n, i;
	
	    	if (n != V.length) { return null; }
	
	    	var dot = 0, mod1 = 0, mod2 = 0;
	    	// Work things out in parallel to save time
	    	this.each(function(x, i) {
	      		dot += x * V[i-1];
	      		mod1 += x * x;
	      		mod2 += V[i-1] * V[i-1];
	    	});
	
	    mod1 = Math.sqrt(mod1); mod2 = Math.sqrt(mod2);
	    if (mod1*mod2 === 0) { return null; }
	
	    var theta = dot / (mod1*mod2);
	    if (theta < -1) { theta = -1; }
	    if (theta > 1) { theta = 1; }
	
	    return Math.acos(theta);
	  },
		###
		
		realAngle: (v) ->
			#dot   = @dot v
			angle = (@angle() - v.angle())
			#angle = Math.acos dot / (@length() * v.length())
			
			#if angle < 0 then angle += 360
			#if dot < 0 then angle += if angle > 0 then Math.PI else -Math.PI
			
			angle
		
		angleTo: (v) ->
			@angle() - v.angle()
		
		angleFrom: (v) ->
			v.angle() - @angle()
		
		equal: @::equals = (v) ->
			Vector.equals @, v
		
		isZero: ->
			@i is 0 and @j is 0
		
		isUnit: @::isNormal = ->
			@length() is 1
		
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
	
	Math.Vector = Vector if not Math.Vector?
