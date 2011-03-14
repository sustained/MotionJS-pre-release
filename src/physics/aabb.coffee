define [
	'classutils'
	'math/vector'
], (ClassUtils, Vector) ->
	class AABB
		# top, bottom, left, right
		t: 0
		b: 0
		l: 0
		r: 0
		
		constructor: (center = new Vector, size = [0, 0]) ->
		 	@set center, size
		
		Motion.ext AABB, ClassUtils.Ext.Accessors
		
		setT: (@t) ->
		setB: (@b) ->
		setL: (@l) ->
		setR: (@r) ->
		
		set: (@center, size) ->
			if size
				@hW = size[0] or 0
				@hH = size[1] or 0
			
			@t = @center.j - @hH
			@b = @center.j + @hH
			@l = @center.i - @hW
			@r = @center.i + @hW
		
		intersects: (aabb) ->
			sumX = @hW + aabb.hW
			sumY = @hH + aabb.hH
			diff = Vector.subtract(@center, aabb.center).abs()
			
			return diff.i < sumX and diff.j < sumY
		
		contains: (aabb) ->
			return \
				aabb.t > @t and
				aabb.b < @b and
				aabb.l > @l and
				aabb.r < @r
		
		
	AABB