#
define [
	'world/world'

	'client/graphics/canvas'
	'client/graphics/sprite'
	'client/graphics/tileset'
	'client/graphics/tilemap'

	'utilities/astar'
	'utilities/grid'
], (World, Canvas, Sprite, TileSet, TileMap, AStar, Grid) ->
	class Chunk
		constructor: ->


	class TiledWorld extends World
		@GRID_SIZE: [32, 32]

		layers:  null
		_zIndex: null

		constructor: ->
			super

			@pathFinder = new AStar()

			@layers  = {}
			@_zIndex = 0

		isLayer: (name) ->
			return @layers[name] or false

		addLayer: (name, size, index) ->
			return if @isLayer name

			@layers[name] = tilemap: new TileMap(new TileSet(name, size: TiledWorld.GRID_SIZE),
				new Grid(rows:size[0], cols:size[1]))

			@layers[name].index = @_zIndex++

		update: (dt, t) ->


		render: (g) ->
			g.clearRect 0, 0, 1024, 768
			context.translate -@camera.position.i.round(), -@camera.position.j.round()
			#world.render context, @camera
			#@camera.render canvas
			context.translate @camera.position.i.round(), @camera.position.j.round()

###
		constructor: ->
			@cam = [0, 0]

			@gridWalls = new Grid
				rows: 32
				cols: 32
				fill: -> if random() < 0.75 then 0 else 1

			@gridGround = new Grid
				rows: 32
				cols: 32
				fill: -> 1

			@astar = new AStar @gridWalls, 'diagonal', 'diagonal'


		load: ->
			@tsWalls = new TSet 'walls', size: 32
			@tmWalls = new TMap @tsWalls, @gridWalls
			@tmWalls.prerender()

			Unit.setTileMap @tmWalls
			Unit.setAStar @astar
			window.unit = @unit = new Unit()

			@structures = {}

			@tsGround = new TSet 'ground', size: 32
			@tmGround = new TMap @tsGround, @gridGround
			@tmGround.prerender()
###
