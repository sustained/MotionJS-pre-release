Array.isArray = (object) -> toString.call(object) is '[object Array]'

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
Array::remove = (remove, all = false) ->
	index = @indexOf remove
	return @ if index is -1
	
	if all is false
		@splice index, 1
		return @
	
	while index > -1
		@splice index, 1
		index = @indexOf remove
	@
