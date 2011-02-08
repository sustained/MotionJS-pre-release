# speed of light
Math.C = 299792458.0

# gravitational constant
Math.G = 6.6742e-11

# ellipse kappa thingy ma jigga... find out what this really is and how the fuck it works
Math.K = 0.5522848

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