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

		constructor: (@_grid, options = {}) ->
			if isArray @_grid[0]
				@rows  = @_grid[0].length
				@cols  = @_grid.length
				@_grid = flatten @_grid
			else
				@rows = options.width
				@cols = floor @_grid.length / @rows

			@size = @rows * @cols

		getCell: (x, y) ->
			index = (@rows * y) + x
			return false if index < 0 or index > @size
			return @_grid[index]

		isPassable: (x, y) ->
			(x > -1 and x < @rows) and (y > -1 and y < @cols) and @getCell(x, y) is 0
