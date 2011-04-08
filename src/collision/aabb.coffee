define [
	'classutils'
	'math/vector'
], (ClassUtils, Vector) ->
	class AABB
		# Local and world extents
		local: null
		world: null
		
		# Dimensions
		h: 0
		w: 0
		
		# Half dimensions
		hh: 0
		hw: 0
		
		_isSquare: false
		
		render: (style) ->
			canvas.polygon [
				new Vector @world.l, @world.t
				new Vector @world.r, @world.t
				new Vector @world.r, @world.b
				new Vector @world.l, @world.b
			], style
			
			#canvas.polygon [
			#	new Vector @position.i - @local.l, @position.j - @local.t
			#	new Vector @position.i + @local.r, @position.j - @local.t
			#	new Vector @position.i + @local.r, @position.j + @local.b
			#	new Vector @position.i - @local.l, @position.j + @local.b
			#], style
		
		constructor: (position, extents = {}) ->
			@local = {t:0, b:0, l:0, r:0}
			@world = {t:0, b:0, l:0, r:0}
			
			@position = new Vector
			
			@set position, extents
		
		#Motion.extend AABB, ClassUtils.Ext.Accessors
		
		setTop:     (top)     -> @local.t = top
		setBottom:  (bottom)  -> @local.b = bottom
		setLeft:    (left)    -> @local.l = left
		setRight:   (right)   -> @local.r = right
		
		###
		#	Set the AABBs size via a width and height.
		###
		setDimensions: (size) ->
			@hh = (@h = size[1]) / 2
			@hw = (@w = size[0]) / 2
			
			@_isSquare = @h is @w
			
			@local.t = @hh
			@local.b = @hh
			@local.l = @hw
			@local.r = @hw
		
		###
		#	Set the AABBs size via a top, bottom, left and right value.
		###
		setExtents: (extents = {}) ->
			if isNumber extents then extents = t:extents, b:extents, l:extents, r:extents
			
			@local = Motion.extend @local, extents
			
			@hh = (@h = @local.t + @local.b) / 2
			@hw = (@w = @local.l + @local.r) / 2
			
			@_isSquare = @h is @w
		
		###
		#	Set the world position of the AABB, updates the worldExtents.
		###
		setPosition: (position) ->
			return if not position
			
			@position.copy position
			@world.t = @position.j - @local.t
			@world.b = @position.j + @local.b
			@world.l = @position.i - @local.l
			@world.r = @position.i + @local.r
		
		###
		#	Set the position and/or extents of the AABB.
		###
		set: (position, extents) ->
			@setPosition position
			
			if isObject extents
				@setExtents extents
			else if isArray extents
				@setDimensions extents
		
		intersects: (aabb) ->
			diff = Vector.subtract(@position, aabb.position).abs()
			
			diff.j < @hh + aabb.hh and diff.i < @hw + aabb.hw
		
		contains: (aabb) ->
			aabb.world.t > @world.t and aabb.world.b < @world.b and
			aabb.world.l > @world.l and aabb.world.r < @world.r
		
		containsPoint: (v) ->
			v.j > @world.t and v.j < @world.b and
			v.i > @world.l and v.i < @world.r
