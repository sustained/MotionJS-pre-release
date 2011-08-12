define [
	'shared/utilities/astar'
], (AStar) ->
	{Vector} = Math

	return ->
		describe 'AStar', ->
			grid = new AStar.Grid [
				[0, 0, 0, 1, 0, 0, 0]
				[0, 1, 0, 1, 0, 1, 0]
				[0, 1, 0, 1, 0, 1, 0]
				[0, 1, 0, 1, 0, 1, 0]
				[0, 1, 0, 1, 0, 1, 0]
				[0, 1, 0, 1, 0, 1, 0]
				[0, 1, 0, 0, 0, 1, 0]
			]

			from = [0, 6]
			goal = [6, 6]

			astar = new AStar grid
			search = astar.search from, goal

			it '', ->
