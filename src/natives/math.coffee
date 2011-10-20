define ->
	# speed of light
	C = 299792458.0

	# gravitational constant
	G = 6.6742e-11

	# ellipse kappa thingy ma jigga... find out what this really is and how the fuck it works
	K = 0.5522848

	HALFPI = Math.PI * 0.5
	TWOPI  = Math.PI * 2

	rand = (min, max) ->
		if not max?
			return Math.random() if not min?
			[min, max] = [0, min]

		if min > max
			[min, max] = [max, min]

		( ( Math.random() * (max - min) ) + min ).round()

	# find the nearest number to n, in set
	nearest = (n, set...) ->
		ret = n
		low = dif = null
		for i in set
			continue if isNaN i
			dif = Math.abs(Math.max(i, n)) - Math.abs(Math.min(i, n))
			if low is null or dif < low
				low = dif
				ret = i
		ret

	deg = (radians) ->
		radians * (180 / Math.PI)

	rad = (degrees) ->
		degrees * (Math.PI / 180)

	sq = (n) ->
		n * n

	lerp = (start, change, t) -> (change * t) + start

	norm = (n, range) ->
		range = range.array() if isVector range

		(n - range[0]) / (range[1] - range[0])

	wrap = (n, min, max) ->
		return (n - min) + max if n < min
		return (n - max) + min if n > max

		n

	clamp = (n, min, max) ->
		return min if n < min
		return max if n > max

		n

	remap = (n, current, target) ->
		current = current.array() if isVector current
		target  = target.array()  if isVector target

		(target[0] + (target[1] - target[0])) * ((n - current[0]) / (current[1] - current[0]))

	{C, G, K, HALFPI, TWOPI, rand, nearest, deg, rad, sq, lerp, norm, wrap, clamp, remap, TAU: TWOPI, degrees: deg, radians: rad}
