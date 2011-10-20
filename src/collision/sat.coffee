define [
	'math/vector'
	'geometry/circle'
	'geometry/polygon'
], (Vector, Circle, Polygon) ->
	###
	
	Polygon#project = (axis) ->
		min = max = axis.dot @verticesT[0]
		
		i = 1; l = @verticesT.length
		
		while i < l
			dot = axis.dot @verticesT[i]
			min = dot if dot < min
			max = dot if dot > max
			i++
		
		[min, max]
	###
	
	class SeperatingAxisTheorem
		@test: (a, b, statik = true) ->
			aIsPoly = a instanceof Polygon
			bIsPoly = b instanceof Polygon
			
			return @checkCircles  a, b, statik if not aIsPoly and not bIsPoly
			return @checkPolygons a, b, statik if     aIsPoly and     bIsPoly
			
			return @checkCircleVersusPolygon a, b if not aIsPoly
			return @checkCircleVersusPolygon b, a if not bIsPoly
		
		@checkCircles: (a, b) ->
			aSubtractB  = a.position.subtract b
			totalRadius = a.radiusT + b.radiusT
			distSquared = aSubtractB.lengthSquared()
			#distSquared = b.position.distanceSquared a.position
			#distSquared = a.clone().subtract(b).lengthSquared()
			
			#distSquared = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)
			
			return false if distSquared > (totalRadius * totalRadius)
			
			distance   = Math.sqrt distSquared
			#distance   = Vector.subtract(a.position, b.position).normalize()
			difference = totalRadius - distance
			
			collision =
				shapeA: a
				shapeB: b
				distance: distance
				separation: Vector.multiply distance, difference
				shapeAContained: a.radiusT <= b.radiusT && dist <= b.radiusT - a.radiusT
				shapeBContained: b.radiusT <= a.radiusT && dist <= a.radiusT - b.radiusT
				vector: aSubtractB.normalize()
			
			collision.overlap = collision.separation.length()
			
			collision
		
		@checkPolygons: (a, b, statik) ->
			i = 0
			j = 0
			
			# smallest and largest for shape a
			min1 = 0
			max1 = 0
			# smallest and largest for shape b
			min2 = 0
			max2 = 0
			# axis for projection
			axis = null
			
			test1   = 0
			test2   = 0
			offset  = 0
			testNum = 0
			
			vertsA = a.verticesT.concat() # transformedVertices
			vertsB = b.verticesT.concat() # transformedVertices
			
			vertsALen = vertsA.length
			vertsBLen = vertsB.length
			
			#axesA = a.axes.concat()
			#axesB = a.axes.concat()
			
			collision = {}
			shortestDistance = Number.MAX_VALUE
			
			# handle lines?
			###
			if vertsALen is 2
				temp = Vector.subtract vertsA[1], vertsA[0]
				temp.i = -temp.i
				temp.truncate 0.0000000001
				vertsA.push vertsA[1].clone().add temp
			if vertsBLen is 2
				temp = Vector.subtract vertsB[1], vertsB[0]
				temp.i = -temp.i
				temp.truncate 0.0000000001
				vertsB.push vertsB[1].clone().add temp
			###
			
			###
			for(I = 0; I < A.num_edges; I ++) {
				Vector N = Vector(-A.EdgeDir[I].y, A.EdgeDir[I].x);
				
				if (AxisSeparatePolygons(N, A, B))
					return false;
				} 
			}
			
			for(I = 0; I < B.num_edges; I ++) {
				Vector N = Vector(-B.EdgeDir[i].y, B.EdgeDir[I].x);
				
				if (AxisSeparatePolygons (N, A, B)) 
					return false; 
				}
				return true;
			###
			
			while i < vertsALen
				axis = if statik then a.axes[i] else @findNormalAxis vertsA, i
				
				pA = a.project axis
				pB = b.project axis
				
				return false if pA[0] - pB[1] > 0 or pB[0] - pA[1] > 0
				
				distance = -(pB[1] - pA[0])
				
				if Math.abs(distance) < shortestDistance
					collision.vector  = axis
					collision.overlap = distance
					shortestDistance  = Math.abs distance
				
				i++
			
			while j < vertsBLen
				axis = @findNormalAxis vertsB, j
				
				pA = a.project axis
				pB = b.project axis
				
				return false if pA[0] - pB[1] > 0 or pB[0] - pA[1] > 0
				
				distance = -(pB[1] - pA[0])
				
				if Math.abs(distance) < shortestDistance
					collision.vector  = axis
					collision.overlap = distance
					shortestDistance  = Math.abs distance
				
				j++
			
			collision.shapeA = a
			collision.shapeB = b
			
			collision.separation = Vector.multiply collision.vector, collision.overlap
			collision
				
		@checkCircleVersusPolygon: (circ, poly) ->
			
			# vectors
			a = circ.position
			b = poly.position
			
			# test numbers
			test1 = test2 = testNum = min1 = max1 = min2 = max2 = 0
			
			normalAxis = null
			offset = 0
			vectorOffset = 0
			vectors = []
			collision = {}
			p2 = []
			distance = 0
			testDistance = Number.MAX_VALUE
			closestVector = new Vector
			
			verts    = poly.vertices.concat()
			vertsLen = verts.length
			
			vectorOffset = Vector.subtract b, a
			
			if vertsLen is 2
				temp = Vector.subtract verts[1], verts[0]
				temp.i = -temp.i
				verts.push verts[1].clone().add temp.truncate 0.00001
			
			i = 0; while i < vertsLen
				distance = (
					(a.i - (b.i + verts[i].i)) *
					(a.i - (b.i + verts[i].i)) +
					(a.j - (b.j + verts[i].j)) *
					(a.j - (b.j + verts[i].j))
				)
				
				if distance < testDistance
					testDistance  = distance
					closestVector = Vector.add b, verts[i]
				
				i++
			
			normalAxis = Vector.subtract(closestVector, a).normalize()
			
			
			min1 = max1 = normalAxis.dot verts[0]
			
			j = 1; while j < vertsLen
				testNum = normalAxis.dot verts[j]
				
				min1 = testNum if testNum < min1
				max1 = testNum if testNum > max1
				
				j++
			
			max2  = circ.radiusT
			min2 -= circ.radiusT
			
			offset = normalAxis.dot vectorOffset
			
			min1 += offset
			max1 += offset
			
			test1 = min1 - max2
			test2 = min2 - max1
			
			return false if test1 > 0 or test2 > 0
			
			i = 0; while i < vertsLen
				normalAxis = @findNormalAxis verts, i
				
				min1 = max1 = normalAxis.dot verts[0]
				
				j = 1; while j < vertsLen
					testNum = normalAxis.dot verts[j]
					
					min1 = testNum if testNum < min1
					max1 = testNum if testNum > max1
					
					j++
				
				max2 =  circ.radiusT
				min2 = -circ.radiusT
				
				offset = normalAxis.dot vectorOffset
				
				min1 += offset
				max1 += offset
				
				test1 = min1 - max2
				test2 = min2 - max1
				
				# we're done!
				return false if test1 > 0 or test2 > 0
				
				i++
			
			collision.overlap = -(max2 - min1)
			collision.unitVector = normalAxis
			collision.shapeA = poly
			collision.shapeB = circ
			collision.separation = new Vector(
				normalAxis.i * (max2 - min1) * -1
				normalAxis.j * (max2 - min1) * -1
			)
			
			collision
		
		@findNormalAxis: (vertices, index) ->
			a = vertices[index]
			b = if index >= vertices.length - 1 then vertices[0] else vertices[index + 1]
			
			new Vector( -(b.j - a.j), (b.i - a.i)).normalize()
		
	SeperatingAxisTheorem