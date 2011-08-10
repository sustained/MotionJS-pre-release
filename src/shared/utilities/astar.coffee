define [
	'shared/utilities/binaryheap'
], (BinaryHeap) ->
	{resolveDotPath} = Motion.Utils.String
	{abs, max, pow, sqrt, Vector} = Math
	{isVector} = Vector

	V = (i, j) -> new Vector i, j

	class Node
		id: null
		parent: null
		position: null

		f: null
		g: null
		h: null

		constructor: (@parent, @position, @g = 0, @h = 0) ->
			if @parent isnt null and @parent.i? and @parent.j?
				[@position, @g, @h] = [@parent, @position, @g]
				@parent = null

			@f = @g + @h

		getId: ->
			return @id if @id?
			@id = [@position.i, '-', @position.j].join ''

	class AStar
		@Node: Node

		@heuristic:
			diagonal: (point, goal) ->
				max abs(point.i - goal.i), abs(point.j - goal.j)
			euclidean: (point, goal) ->
				sqrt pow(point.i - goal.i, 2) + pow(point.j - goal.j, 2)
			manhattan: (point, goal) ->
				abs(point.i - goal.i) + abs(point.j - point.j)
		
		@direction:
			one: (north, east, south, west, n, e, s, w, result) ->
				if north
					result.push V e, n if east and grid[n][e]
					result.push V w, n if west and grid[n][w]
				if south
					result.push V e, s if east and grid[s][e]
					result.push V w, s if west and grid[s][w]
			two: (north, east, south, west, n, e, s, w, result) ->
				north = n > -1
				west  = w > -1
				south = s < @rows
				east  = e < @cols

				if east
					result.push V e, n if north and grid[n][e] is 0
					result.push V e, s if south and grid[s][e] is 0
				if west
					result.push V w, n if north and grid[n][w] is 0
					result.push V w, s if south and grid[s][w] is 0

		getDirections: (point) ->
			[x, y] = [point.i, point.j]
			result = []

			n = y - 1
			s = y + 1
			w = x - 1
			e = x + 1

			$n = n > -1   and @grid[n][x] is 0
			$w = w > -1   and @grid[w][y] is 0
			$s = s < rows and @grid[s][x] is 0
			$e = e < cols and @grid[e][y] is 0

			result.push V x, n if $n
			result.push V w, y if $w
			result.push V x, s if $s
			result.push V e, y if $e

			@directionMethod $n, $e, $s, $w, n, e, s, w, result

			result

		open:   null
		closed: null

		heuristicFn: null
		directionFn: null

		constructor: (@grid, heuristic = 'manhattan', direction = 'diagonal') ->
			@open = new BinaryHeap()
			@closed = {}

			@cols = @grid[0].length
			@rows = @grid.length
			@limit = @cols * @rows

			@heuristicMethod = resolveDotPath heuristic, AStar.heuristic
			@directionMethod = {
				diagonal:  AStar.direction.one, diagonalFree:  AStar.direction.two
				euclidean: AStar.direction.one, euclideanFree: AStar.direction.two
			}[direction].bind @

		addNode: (node) ->
			@open.push node
			@closed[[node.position.i, '-', node.position.j].join ''] = node

		isKnown: (vec) ->
			@closed[[vec.i, '-', vec.j].join '']?

		getKnown: (node) ->
			@closed[node.getId()] or false

		search: (from, goal) ->
			from = V from if isArray from
			goal = V from if isArray goal

			@addNode new Node from

			while @open.size() > 0
				node = @open.pop()
				return node if Vector.equal node.position, goal

				directions = @getDirections node.point
				debugger
				for direction in directions
					known = @isKnown direction
					length = node.length + @heuristicMethod node.position, direction
					if not known or known.length > newLength
						@open.remove known if known
						@addNode new Node node, direction, length
