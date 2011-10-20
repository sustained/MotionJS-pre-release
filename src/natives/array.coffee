#
define ->
	isArray = (object) -> object? and Object::toString.call(object) is '[object Array]'

	sum = (array) ->
		sum = 0
		sum += i for i in array
		sum

	unique = (array) ->
		unique = []
		for i in array
			unique.push i if not i in array
		unique

	#if not Array::each
	#	Array::each = Array::forEach

	# Return a copy of the array with all null/undefined values removed.
	compact = (array) ->
		res = []
		for i in array then res.push i if i?
		res

	# Remove one (or all) value(s) from an array
	remove = (array, remove, all = false) ->
		index = array.indexOf remove
		return @ if index is -1

		if all is false
			array.splice index, 1
			return array

		while index > -1
			array.splice index, 1
			index = array.indexOf remove

		array

	random = (array) ->
		array[Math.rand 0, array.length - 1]

	{isArray, sum, unique, compact, remove, random}
