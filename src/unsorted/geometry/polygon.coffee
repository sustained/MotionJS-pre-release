define [
	'geometry/shape'
	'math/vector'
	'collision/aabb'
], (Shape, Vector, AABB) ->
	class Polygon extends Shape
		@createAABB: (position, extents = {}) ->
			extents = Motion.extend {t:0, r:0, b:0, l:0}, extents
			
			aabb = new @ [
				
			]
		
		@createShape: (sides, radius = 100, position = new Vector) ->
			return false if sides < 3
			
			angle    = 0
			rotation = Math.TAU / sides
			vertices = []
			
			i = 0; while i < sides
				angle = (i * rotation) + ((Math.PI - rotation) * 0.5)
				vertices.push new Vector(Math.cos(angle), Math.sin(angle)).multiply radius
				i++
			
			new @ vertices, position, [radius, radius]
		
		@createRectangle: (width, height, position = new Vector) ->
			hW = width  / 2
			hH = height / 2
			
			rect = new @ [
				new Vector -hW, -hH
				new Vector  hW, -hH
				new Vector  hW,  hH
				new Vector -hW,  hH
			], position, [width, height]
			
			rect
		
		@createSquare: (width, position) ->
			@createRectangle width, width, position
		
		area: 0
		
		center:   null
		offset:   null
		
		calculateAABBExtents: ->
			minX = minY =  Number.MAX_VALUE
			maxX = maxY = -Number.MAX_VALUE
			
			for v in @vertices
				minX = v.i if v.i < minX
				maxX = v.i if v.i > maxX
				minY = v.j if v.j < minY
				maxY = v.j if v.j > maxY
			
			{t:minY.abs(), b:maxY, l:minX.abs(), r:maxX}
		
		constructor: (@_vertices = [], position = new Vector, size = [0, 0]) ->
			super position
			
			@size = size
			@_axes       = []
			@_verticesT  = []
			@projections = []
			#@area   = 0
			#@center = new Vector
			#@offset = new Vector
			
			@defineAxes()
			@defineProjections()
			#@defineArea()
			#@defineCenter()
		
		@get 'axes',     -> @_axes
		@get 'vertices', -> @_vertices
		
		@get 'verticesT', ->
			if @transformed is false
				transformed  = []
				@transformed = true

				transformed.push vert.transform @transform for vert in @_vertices

				@_verticesT = transformed

			@_verticesT
		
		draw: (g) ->
			#graphics.translate @position.i, @position.j
			
			verts = @verticesT
			
			g.beginPath()
			g.moveTo verts[0].i, verts[0].j
			g.lineTo vec.i, vec.j for vec in verts
			g.lineTo verts[0].i, verts[0].j
			g.closePath()
			
			if @fill
				g.fillStyle = @fill.toString()
				g.fill()
			
			if @stroke
				g.strokeStyle = @stroke.toString()
				g.stroke()
			
			#graphics.translate -@position.i, -@position.j
		
		# old
		defineArea: ->
			sum1 = sum2 = 0
			
			i = j = 0; l = @vertices.length
			while i < l
				j = (i + 1) % l
				sum1 += @vertices[i].i * @vertices[j].j
				sum2 += @vertices[i].j * @vertices[j].i
				
				i++
			
			@area = 0.5 * (sum1 - sum2).abs()
		
		defineCenter: ->
			totalX = totalY = 0
			length = @vertices.length
			
			for vector in @vertices
				totalX += vector.i
				totalY += vector.j
			
			@center = new Vector totalX / length, totalY / length
		
		#findNormalAxis: (index) ->
		#	a = @vertices[index]
		#	b = if index >= @vertices.length - 1 then @vertices[0] else @vertices[index + 1]
		#	
		#	new Vector( -(b.j - a.j), (b.i - a.i)).normalize()
		
		collide: (polygon) ->
		
		project: (axis) ->
			min = max = axis.dot @verticesT[0]
			
			i = 1; l = @verticesT.length
			
			while i < l
				dot = axis.dot @verticesT[i]
				min = dot if dot < min
				max = dot if dot > max
				i++
			
			[min, max]
		
		cacheSelfProjection: ->
			axes = []
			
			while i < @verticesT.length
				axis = @findNormalAxis @verticesT, i
				
				axes.push @project axis
				
				i++
			
			axes
		
		###
		@findNormalAxis: (vertices, index) ->
			a = vertices[index]
			b = if index >= vertices.length - 1 then vertices[0] else vertices[index + 1]
			
			new Vector( -(b.j - a.j), (b.i - a.i)).normalize()
			
		###
		
		defineAxes: ->
			i = 0; l = @vertices.length
			while i < l
				a = @vertices[i]
				b = @vertices[++i % l]
				@_axes.push Vector.subtract(b, a).rightNormal().normalize()
			#@removeDuplicateAxes()
		
		defineProjections: ->
			i = 0; l = @axes.length
			while i < l
				@projections.push @project @axes[i]
				i++
		
		removeDuplicateAxes: ->
			i = j = 0
			l = @axes.length
			while i < l
				while j < l
					@axes.splice j, 1 if @axes[i].equals(@axes[j]) or @axes[i].equals Vector.invert @axes[j]
					j++
				i++
			return