#
define ->
	{floor, round, random} = Math
	{isArray, isObject, isNumber, flatten} = _

	class Cell
		@TYPES:
			OBJECT: 1 << 1
			NUMBER: 1 << 2

		constructor: ->

	class Grid
		@Cell: Cell

		_grid: null

		rows: null
		cols: null
		size: null

		setGrid: (grid = [], width = null) ->
			return false if not isArray(grid)

			if isArray(grid[0])
				rows = grid.length
				cols = grid[0].length
				grid = flatten grid
			else
				if not width
					console.log 'Specify width for 1d grid'
					return
				rows = width
				cols = if rows <= 0 then 0 else
					floor grid.length / rows

			@_grid = grid
			@setSize rows, cols

		setSize: (rows = null, cols = null) ->
			@rows = rows if rows?
			@cols = cols if cols?
			@size = @rows * @cols

		constructor: (options = {}) ->
			if options.grid?
				@setGrid options.grid, options.width
			else
				@setSize options.rows, options.cols

			if options.fill
				@setRandom options.fill

		__randomCallback: -> round(random())

		setRandom: (callback = @__randomCallback) ->
			if not @size
				console.log 'setSize first'
				return

			grid = []

			i = 0
			while i < @size
				grid.push callback()
				i++

			@setGrid grid, @rows

		setCell: (x, y, value) ->
			index = (@rows * y) + x
			@_grid[index] = value

		getCell: (x, y) ->
			index = (@rows * y) + x
			return false if index < 0 or index > @size

			return @_grid[index]

		isPassable: (x, y) ->
			# (x > -1 and x < @rows) and (y > -1 and y < @cols) and
			@getCell(x, y) is 0
