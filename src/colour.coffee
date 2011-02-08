define ['motion'], (Motion) ->
	class Colour
		@ALPHA: [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1]
		@DEFAULT_ALPHA: 1.0
		
		@random: (rgba = true)->
			random = new Colour(
				rand 0, 255
				rand 0, 255
				rand 0, 255
				Colour.ALPHA.random()
			)
			return if rgba is true then random.rgba() else random
		
		@colours = {}
		
		@create: (name, r, g, b, a) ->
			if not @get name
				@colours[name] = new @(r, g, b, a)
			@colours[name]
	
		@get: (name) ->
			@colours[name] ? false
	
		parts: []
	
		constructor: (r = 0, g = 0, b = 0, a = Colour.DEFAULT_ALPHA) ->
			if isArray(r) and @parts.length >= 3
				@parts = r
			
				@parts.push a if @parts.length < 3
			else
				@parts = [r, g, b, a]
	
		r: (r) -> @parts[0] = r; @
		g: (g) -> @parts[1] = g; @
		b: (b) -> @parts[2] = b; @
		a: (a) -> @parts[3] = a; @
	
		lighter: ->
		darker:  ->
	
		rgb:  ->
			"rgb(#{@parts.slice(0, 3).join ', '})"
		
		rgba: ->
			"rgba(#{@parts.join ', '})"
	
		copy: -> 
			new Colour @parts[0], @parts[1], @parts[2], @parts[3]
		duplicate: @::copy
	
	Colour.create 'white',
		255, 255, 255
	Colour.create 'black',
		  0,   0,   0
	Colour.create 'red',
		255,   0,   0
	Colour.create 'green',
		  0, 255,   0
	Colour.create 'blue',
		  0,   0, 255
	Colour.create 'yellow',
		255, 255,   0
	
	Colour