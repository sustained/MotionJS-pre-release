#
class Hash
	length: 0

	constructor: (keys = {}, vals) ->
		@_hash = {}

		if isArray(keys) and isArray(vals)
			@set keys, vals
		else if isObject keys
			@set keys

	set: (key, val) ->
		if isArray(key) and isArray(val) and key.length is val.length
			[ind, max] = [0, key.length]
			while max > ind
				@set key[ind], val[ind]; ind++
			@length
		else if isObject key
			for k, v of key then @set k, v
			@length
		else
			@_hash[key] = val
			++@length

	get: (key, def = null) ->
		return @_hash[key] if key of @_hash
		def

	each: (iter) ->
		iter.call null, k, v for k, v of @_hash

	eachKey: (iter) ->
		iter.call null, k for k of @_hash
	eachVal: (iter) ->
		iter.call null, v for k, v of @_hash

	keys: ->
		Object.keys @_hash

	vals: ->
		v for k, v of @_hash

	invert: (self = false) ->
		hash = new Hash @vals(), @keys()

		if self is true
			@_hash  = hash._hash
			@length = hash.length
			@
		hash

define -> Hash
