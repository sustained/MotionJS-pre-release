define [
	'client/assets/image'
	'client/graphics/tileset'
	'client/animation/tileset'
], (Image, TileSet, TSAnim) ->
	Image.setUrl '../assets/spec/image/'
	image = new Image('foo', '3x3_8px_rbg.png').load()

	sequence = [1, 2, 3, 6, 5, 4, 8, 9, 7] # rgb, rgb, rgb ...

	describe 'Animation - TileSet', ->
		describe 'construction', ->
			it 'should fall back to sensible defaults for missing options', ->
				anim = new TSAnim()
 
