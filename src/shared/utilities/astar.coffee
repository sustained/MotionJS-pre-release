define [
	'shared/utilities/binaryheap'
], (BinaryHeap) ->
	{isArray} = _
	{resolveDotPath} = Motion.Utils.String
	{abs, max, pow, sqrt, Vector} = Math
	{isVector} = Vector

	V = (i, j) -> new Vector i, j

	diagonal = (pA, pB) -> pA[0] is pB[0] or pA[1] is pB[1]

	class Node
		_id = 0

		id: null
		score: null
		length: null
		parent: null
		position: null

		constructor: (@position, @parent = null, @length = 0) ->
			@id = _id++

	class Grid
		@SIZE: 16

		constructor: (@_grid, @size = Grid.SIZE) ->
			@rows = @_grid[0].length
			@cols = @_grid.length
			@total = @rows * @cols

		isPassable: (x, y) ->
			(y > -1 and y < @cols) and (x > -1 and x < @rows) and @_grid[y][x] is 0

	class AStar
		@Node: Node
		@Grid: Grid

		@heuristic:
			diagonal: (a, b) ->
				max abs(a[0] - b[0]), abs(a[1] - b[1])
			euclidean: (a, b) ->
				sqrt pow(a[0] - b[0], 2) + pow(a[1] - b[1], 2)
			manhattan: (a, b) ->
				abs(a[0] - b[0]) + abs(a[1] - b[1])

		@direction:
			one: (nValid, eValid, sValid, wValid, n, e, s, w, results) ->
				if nValid
					if eValid and @grid.isPassable e, n
						results.push [e, n]
					if wValid and @grid.isPassable w, n
						results.push [w, n]
				if sValid
					 if eValid and @grid.isPassable e, s
					 	results.push [e, s]
					 if wValid and @grid.isPassable w, s
					 	results.push [w, s]

			two: (nValid, eValid, sValid, wValid, n, e, s, w, results) ->
				nValid = n > -1
				wValid = w > -1
				sValid = s < @rows
				eValid = e < @cols

				if eValid
					results.push [e, n] if nValid and @grid.isPassable e, n
					results.push [e, s] if sValid and @grid.isPassable e, s
				if wValid
					results.push [w, n] if nValid and @grid.isPassable w, n
					results.push [w, s] if sValid and @grid.isPassable w, s

		getDirections: (point) ->
			[x, y] = point
			result = []

			n = y - 1
			w = x - 1
			s = y + 1
			e = x + 1

			_n = n > -1 and @grid.isPassable x, n
			_w = w > -1 and @grid.isPassable w, y
			_s = s < @grid.cols and @grid.isPassable x, s
			_e = e < @grid.rows and @grid.isPassable e, y

			result.push [x, n] if _n
			result.push [x, s] if _s
			result.push [w, y] if _w
			result.push [e, y] if _e

			@directionMethod _n, _e, _s, _w, n, e, s, w, result

			result

		open:   null
		closed: null
		closedCount: null

		from: null
		goal: null

		heuristicFn: null
		directionFn: null

		constructor: (@grid, heuristic = 'euclidean', direction = 'diagonalFree') ->
			@open = new BinaryHeap (node) =>
  				if not node.score?
  					node.score = @heuristicMethod(node.position, @goal) + node.length
  				node.score
			@closed = {}

			@grid = new Grid @grid if isArray @grid

			@heuristicMethod = resolveDotPath heuristic, AStar.heuristic
			@directionMethod = {
				diagonal:  AStar.direction.one, diagonalFree:  AStar.direction.two
				euclidean: AStar.direction.one, euclideanFree: AStar.direction.two
			}[direction].bind @

		pointId: (point) ->
			[point[0], '-', point[1]].join ''

		storeReached: (point, node) ->
			@closed[@pointId(point)] = node

		findReached: (point) ->
			@closed[@pointId(point)]

		addOpenNode: (node) ->
			@open.push node
			@storeReached node.position, node

		weightedDistance: (uno, dos) ->
			return if diagonal(uno, dos) then 10 else 14

		search: (@from, @goal) ->
			@addOpenNode new Node from

			while @open.size() > 0
				node = @open.pop()

				if node.position[0] is goal[0] and node.position[1] is goal[1]
					return node

				directions = @getDirections node.position

				for direction in directions
					known = @findReached direction

					length = node.length + @weightedDistance(node.position, direction)

					if not known or known.length > length
						if known
							open.remove known
						@addOpenNode new Node direction, node, length
			return
