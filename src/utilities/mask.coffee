#
define ->
	class Mask
		constructor: (mask) ->
			i = 0
			while i < mask.length
				index = if i < 31 then 1 << index else false
				break if index is false
				@[mask[i].toUpperCase()] = index
				i++
