define [
	'shared/utilities/astar'
], (AStar) ->
	{Vector} = Math

	return ->
		describe 'AStar', ->
			grid = new AStar.Grid [
				[0, 0, 0, 0, 0, 0, 0]
				[0, 0, 0, 1, 0, 0, 0]
				[0, 0, 0, 1, 0, 0, 0]
				[0, 0, 0, 1, 0, 0, 0]
				[0, 0, 0, 0, 0, 0, 0]
			]
			astar = new AStar grid

			console.log grid, astar

			console.log astar.heuristicMethod
			console.log astar.directionMethod

			try
				console.log astar.search [0, 0], [6, 4]
			catch e
				console.log 'ut oh'
				console.error e
