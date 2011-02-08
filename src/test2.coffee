require ['motion'], (Motion) ->
	hash = new Motion.Hash
	hash.set 'foo', 1
	hash.set 'bar', 2
	hash.set 'baz', 3
	puts inspect hash, true, 2