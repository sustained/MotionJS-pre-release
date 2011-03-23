define ->
	Array::clone = ->
		@.concat()
	
	Array::sum = ->
		sum = 0
		sum += i for i in @
		sum

	Array::append  = Array::push
	Array::prepend = Array::unshift

	Array::map = Array::map ? () ->

	Array::zip = () ->	

	Array::unique = () ->
		uniq = []
		for i in @
			uniq.push i if not i in @
		uniq

	Array::each = Array::forEach ? (func, bind = null) -> func.call bind, i, _i, @ for i in @

	Array::empty = -> @length is 0

	Array::first  = -> @[0]
	Array::random = -> @[Math.rand @length]
	Array::last   = -> @[@length - 1]

	Array::count = (obj) ->
		count = 0
		if isFunction obj
			for i in @ then count++ if obj(i) is true
		else
			for i in @ then count++ if obj is i
		count

	# Example for Array::count usage:
	# 	Array::lt = (n) -> @.count (i) -> i <= n
	# 	puts [1, 2, 3, 4, 5, 6].lt 4

	# Return a copy of the array with all null/undefined values removed.
	Array::compact = ->
		compacted = []
		for i in @ then compacted.push i if i?
		compacted

	Array::remove = (remove) ->
		array  = []
		remove = [remove] if not isArray remove
		for i in @
			continue if i in remove
			array.push i
		array
	
	true