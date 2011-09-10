define [
	'client/assets/image'
	'client/graphics/tileset'
], (Image, TileSet) ->
	return if Motion.env is 'server'

	Image.setUrl '../assets/spec/image/'
	image = new Image('foo', '3x3_8px_rbg.png').load()

	describe 'Graphics - Tileset', ->
		describe 'construction', ->
			it 'should calculate the number of cells correctly', ->
				waitsFor (->
					image.isLoaded()
				), "failed to load the test image", 2500

				runs ->
					tileset = new TileSet 'foo', size: 8
					expect(tileset.cellsX).toEqual 3
					expect(tileset.cellsY).toEqual 3

			it 'should fail if an invalid or no image is passed', ->
				tileset = new TileSet('bar')

				expect(tileset.image).toBeUndefined()
				expect(tileset.cellsX).toEqual -1
				expect(tileset.cellsY).toEqual -1

			it 'should default to 16x16px if no size is specified', ->
				tileset = new TileSet('baz')
				expect(tileset.size[0]).toEqual 16
				expect(tileset.size[1]).toEqual 16
			
			xit 'should also accept an array (width/height) for size', ->
				tileset = new TileSet('quux', size:[16, 24])

	describe 'drawTile', ->
		
