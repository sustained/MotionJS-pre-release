define ['core'], ->
	describe 'Core - Sanity Checks', ->
		it 'Motion should exist', -> expect(Motion).toBeDefined()
		#it 'jQuery should exist', -> expect(jQuery).toBeDefined()
		it 'underscore should exist', -> expect(_).toBeDefined()
