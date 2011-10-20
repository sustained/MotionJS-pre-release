#
define ->
	class Colour
		@DEFAULT_ALPHA: 1.0

		range = Math.rand.bind null, 0, 255
		alpha = -> Math.random().toFixed 2

		@random: (rgba = true) ->
			random = new Colour range(), range(), range(), alpha()

			return if rgba is true then random.rgba() else random

		@colours = {}

		@create: (name, r, g, b, a) ->
			if not @get name
				@colours[name] = new @(r, g, b, a)
			@colours[name]

		@get: (name, clone = true) ->
			colour = @colours[name] ? false
			if colour
				return if clone is true then colour.clone() else colour

		parts: null

		constructor: (r, g, b, a) ->
			@parts = []
			@set r, g, b, a

		set: (r = 0, g = 0, b = 0, a = Colour.DEFAULT_ALPHA) ->
			if Array.isArray(r) and r.length >= 3
				@parts = r ; @parts.push a if @parts.length < 4
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
		@::toString = @::rgba

		copy: (colour) ->
			return if not colour instanceof Colour
			@set colour.parts.concat()
			@

		clone: ->
			new Colour @parts[0], @parts[1], @parts[2], @parts[3]
