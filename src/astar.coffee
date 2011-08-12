define [
	'shared/utilities/astar'
], (AStar) ->
	$grid = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
		[0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
		[0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0]
		[0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]
		[1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1]
		[0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0]
		[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0]
		[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		[0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1]
		[0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
		[0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0]
		[0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0]
		[0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0]
		[0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0]
		[0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0]
		[0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0]
	]

	console.log grid = new AStar.Grid $grid
	console.log astar = new AStar grid

	randomPoint = ->
		loop
			x = Math.floor Math.random() * grid.rows
			y = Math.floor Math.random() * grid.cols
			break if $grid[y][x] is 0
		[x, y]

	from = randomPoint()
	goal = randomPoint()

	jQuery ->
		table = jQuery('<table><thead></thead><tbody></tbody></table>')
			.attr(id: 'aStarTable', cellSpacing: 1)
		tbody = jQuery('tbody', table)

		j = 0 
		while j < $grid.length
			tr = jQuery('<tr></tr>')

			i = 0 
			while i < $grid[0].length
				td = jQuery("<td data-x='#{i}' data-y='#{j}'></td>").html("#{i},#{j}")
				td.addClass 'impassableCell' if $grid[j][i] is 1
				tr.append td
				i++
			tbody.append tr
			j++

		table.appendTo 'body'

		jQuery("td[data-x=#{from[0]}][data-y=#{from[1]}]").addClass 'fromCell'
		jQuery("td[data-x=#{goal[0]}][data-y=#{goal[1]}]").addClass 'goalCell'

		sTime = Date.now()
		search = astar.search from, goal
		fTime = Date.now()

		console.log "search took #{fTime - sTime} ms"

		if search?
			path = []
			path.push search.position
			while search = search.parent
				path.push search.position
			path.reverse()
			console.log path
			for part in path
				jQuery("td[data-x=#{part[0]}][data-y=#{part[1]}]").addClass 'routeCell'
