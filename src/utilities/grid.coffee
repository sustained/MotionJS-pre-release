define ->
	{floor} = Math
	{isArray, flatten} = _

	class Cell
		constructor: ->


	class Grid
		@Cell: Cell

		_grid: null

		rows: null
		cols: null
		size: null

		set: (grid, options = {}) ->
			if isArray grid[0]
				@rows = grid[0].length
				@cols = grid.length
				grid = flatten grid
			else
				@rows = options.width
				@cols = floor grid.length / @rows

			@size = @rows * @cols
			@_grid = grid

		constructor: (grid, options = {}) ->
			@set grid, options if grid?

		setRandom: (options = {}) ->
			grid = []
			size = options.rows*options.cols

			i = 0
			while i < size
				grid.push Math.round Math.rand() * 9
				i++

			@set grid, width: options.rows

		getCell: (x, y) ->
			index = (@rows * y) + x
			return false if index < 0 or index > @size
			return @_grid[index]

		isPassable: (x, y) ->
			(x > -1 and x < @rows) and (y > -1 and y < @cols) and @getCell(x, y) is 0
