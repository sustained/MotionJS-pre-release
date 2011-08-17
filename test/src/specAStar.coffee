define [
	'shared/utilities/astar'
], (AStar) ->
	{Grid} = AStar
	{Vector} = Math

	array1d = [
		0, 0, 0, 1, 0, 0, 0
		0, 1, 0, 1, 0, 1, 0
		0, 1, 0, 1, 0, 1, 0
		0, 1, 0, 1, 0, 1, 0
		0, 1, 0, 1, 0, 1, 0
		0, 1, 0, 1, 0, 1, 0
		0, 1, 0, 0, 0, 1, 0
	]
	array2d = [
		[0, 0, 0, 1, 0, 0, 0]
		[0, 1, 0, 1, 0, 1, 0]
		[0, 1, 0, 1, 0, 1, 0]
		[0, 1, 0, 1, 0, 1, 0]
		[0, 1, 0, 1, 0, 1, 0]
		[0, 1, 0, 1, 0, 1, 0]
		[0, 1, 0, 0, 0, 1, 0]
	]

	return ->
		describe 'AStar', ->
			describe 'Grid', ->
				grid1 = new Grid array1d, width: 7
				grid2 = new Grid array2d

				describe '#constructor()', ->
					it 'should accept a 1d grid and a width', ->
						expect(grid1.rows).toEqual(7)
						expect(grid1.cols).toEqual(7)
						expect(grid1.size).toEqual(49)

					it 'should accept a 2d grid', ->
						expect(grid2.rows).toEqual(7)
						expect(grid2.cols).toEqual(7)
						expect(grid2.size).toEqual(49)

				describe '#getCell()', ->
					it 'should return false when out of bounds', ->
						expect(grid1.getCell(-1, 0)).toBeFalsy()
						expect(grid1.getCell(0, 50)).toBeFalsy()
						expect(grid1.getCell(0, -1)).toBeFalsy()
						expect(grid1.getCell(0, 50)).toBeFalsy()

					it 'should otherwise return the cell', ->
						expect(grid1.getCell(0, 0)).toEqual(0)
						expect(grid1.getCell(1, 1)).toEqual(1)
						expect(grid1.getCell(2, 2)).toEqual(0)
						expect(grid1.getCell(3, 3)).toEqual(1)
						expect(grid1.getCell(4, 4)).toEqual(0)
						expect(grid1.getCell(5, 5)).toEqual(1)
						expect(grid1.getCell(6, 6)).toEqual(0)
