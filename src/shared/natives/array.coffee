Array.isArray = (object) -> object? and Object::toString.call(object) is '[object Array]'

Array.sum = (array) ->
	sum = 0
	sum += i for i in array
	sum

Array.unique = (array) ->
	unique = []
	for i in array
		unique.push i if not i in array
	unique

if not Array::each
	Array::each = Array::forEach

# Return a copy of the array with all null/undefined values removed.
Array.compact = (array) ->
	compact = []
	for i in array then compact.push i if i?
	compact

# Remove one (or all) value(s) from an array
Array.remove = (array, remove, all = false) ->
	index = array.indexOf remove
	return @ if index is -1
	
	if all is false
		array.splice index, 1
		return array
	
	while index > -1
		array.splice index, 1
		index = array.indexOf remove
	
	array

Array.random = (array) ->
	array[Math.rand 0, array.length - 1]