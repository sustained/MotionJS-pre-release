define ->
	class Matrix			
		height: ->
			@m.length

		width: ->
			@m[0].length

		isColumn: ->
			@m[0].length is 1 and @m.length > 1

		isRow: ->
			@m.length is 1 and @m[0].length > 1

		isSquare: ->
			@height() is @width()

	class Matrix2x2 extends Matrix
		@Identity = new @ [
			[1, 0]
			[0, 1]
		]
		
		@Zero = new @ [
			[0, 0]
			[0, 0]
		]

		constructor: (@m = @Identity) ->
			super()

		add: ->
			

		subtract: ->
			

		multiply: (x) ->
			if isArray x
				
			else
				@m = [
					[@m[0][0] * s, @m[0][1] * s]
					[@m[1][0] * s, @m[1][1] * s]
				]

			@m


	class Matrix3x3 extends Matrix
		@Identity = new @ [
			[1, 0, 0]
			[0, 1, 0]
			[0, 0, 1]
		]

		@Zero = new @ [
			[0, 0, 0]
			[0, 0, 0]
			[0, 0, 0]
		]

		constructor: (@m = @Identity) ->
			super()
