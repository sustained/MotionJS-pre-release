define [
	'classutils'
	'math/vector'
], (ClassUtils, Vector) ->
	class AABB
		# position in local space
		extents: null
		
		# position in world space
		t: 0
		b: 0
		l: 0
		r: 0
		
		h: 0
		w: 0
		
		hh: 0
		hw: 0
		
		_isSquare: false
		
		render: (style) ->
			canvas.polygon [
				new Vector @position.i - @l, @position.j - @t
				new Vector @position.i + @r, @position.j - @t
				new Vector @position.i + @r, @position.j + @b
				new Vector @position.i - @l, @position.j + @b
			], style
		
		constructor: (position = new Vector, extents = {}) ->
			@extents = t:0, b:0, l:0, r:0
			
			@set position, extents
		
		#Motion.extend AABB, ClassUtils.Ext.Accessors
		
		setTop:     (top)     -> @extents.t = top
		setBottom:  (bottom)  -> @extents.b = bottom
		setLeft:    (left)    -> @extents.l = left
		setRight:   (right)   -> @extents.r = right
		
		setExtents: (extents = {}) ->
			if isNumber extents
				extents = t:extents, b:extents, l:extents, r:extents
			
			@extents = Motion.extend @extents, extents
			
			#@setTop    extents.t
			#@setBottom extents.b
			#@setLeft   extents.l
			#@setRight  extents.r
			
			@h = @extents.t + @extents.b
			@w = @extents.l + @extents.r
			
			@_isSquare = @h is @w
			
			@hh = @h / 2
			@hw = @w / 2
		
		setPosition: (position) ->
			@position = if position then position.clone() else new Vector
			
			@t = @position.j - @extents.t
			@b = @position.j + @extents.b
			@l = @position.i - @extents.l
			@r = @position.i + @extents.r
		
		set: (position, extents) ->
			@setPosition position
			@setExtents  extents
		
		intersects: (aabb) ->
			diff = Vector.subtract(@position, aabb.position).abs()
			
			diff.j < @hh + aabb.hh and diff.i < @hw + aabb.hw
		
		contains: (aabb) ->
			aabb.t > @t and aabb.b < @b and aabb.l > @l and aabb.r < @r
		
		containsPoint: (v) ->
			v.j > @t and v.j < @b and v.i > @l and v.i < @r
	
	AABB