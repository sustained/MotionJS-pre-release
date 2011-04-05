define ->
	# speed of light
	Math.C = 299792458.0

	# gravitational constant
	Math.G = 6.6742e-11

	# ellipse kappa thingy ma jigga... find out what this really is and how the fuck it works
	Math.K = 0.5522848

	Math.HALFPI = Math.PI * 0.5
	# tau!
	Math.TAU = Math.TWOPI = Math.PI * 2
	
	Math.rand = (min, max) ->
		if not max?
			return Math.random() if not min?
			[min, max] = [0, min]

		if min > max
			[min, max] = [max, min]

		( ( Math.random() * (max - min) ) + min ).round()

	# find the nearest number to n, in set
	Math.nearest = (n, set...) ->
		ret = n
		low = dif = null
		for i in set
			continue if isNaN i
			dif = Math.abs(Math.max(i, n)) - Math.abs(Math.min(i, n))
			if low is null or dif < low
				low = dif
				ret = i
		ret
	
	Math.deg = Math.degrees = (radians) ->
		radians * (180 / Math.PI)
		
	
	Math.rad = Math.radians = (degrees) ->
		degrees * (Math.PI / 180)
	
	Math.sq = (n) ->
		n * n
	
	Math.lerp = (a, b, t) ->
		((b - a) * t) + a
	
	Math.norm = (n, range) ->
		range = range.array() if isVector range
		
		(n - range[0]) / (range[1] - range[0])
	
	Math.wrap = (n, min, max) ->
		return (n - min) + max if n < min
		return (n - max) + min if n > max
		
		n
	
	Math.clamp = (n, min, max) ->
		return min if n < min
		return max if n > max
		
		n
	
	Math.remap = (n, current, target) ->
		current = current.array() if isVector current
		target  = target.array()  if isVector target
		
		(target[0] + (target[1] - target[0])) * ((n - current[0]) / (current[1] - current[0]))
	
	true