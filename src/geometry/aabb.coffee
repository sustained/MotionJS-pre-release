define [
	'classutils'
	'math/vector'
], (ClassUtils, Vector) ->
	NullAABB = t: 0, r: 0, b: 0, l: 0
	
	class AABB extends Polygon
		w: 0
		h: 0
		
		hw: 0
		hh: 0
		
		extents: null
		
		constructor: ( position, extents = {} ) ->
			@extents = NullAABB
			
			@update null, extents
			
			super [
				new Vector -@hw, -@hh
				new Vector  @hw, -@hh
				new Vector  @hw,  @hh
				new Vector -@hw,  @hh
			], position, [@w, @h]
		
		update: (position, extents = {}) ->
			@position = position if position?
			@extents  = Motion.extend @extents, extents
			
			@w = @extents.l + @extents.r
			@h = @extents.t + @extents.b
			
			@hw = @w / 2
			@hh = @h / 2
		
		intersects: (aabb) ->
			sumX = @hw + aabb.hw
			sumY = @hh + aabb.hh
			diff = Vector.subtract(@position, aabb.position).abs()
			
			return diff.i < sumX and diff.j < sumY
		
		contains: (aabb) ->
			aabb.extents.t > @extents.t and aabb.extents.b < @extents.b and
			aabb.extents.l > @extents.l and aabb.extents.r < @extents.r
		
		containsPoint: (v) ->
			v.j >= @extents.t and v.j <= @extents.b and
			v.i >= @extents.l and v.i <= @extents.r
	
	AABB