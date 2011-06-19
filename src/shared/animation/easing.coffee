define ->
	Easing = 
		linear: (t) -> t
		smooth: (t) -> t*t * (3 - 2 * t)
		average: (t, e, s = 5) -> # time, end (target), slowdown factor
			((t * (s - 1)) + e) / s
		quadratic:
			in:    (t) ->  t*t
			out:   (t) -> -t * (t - 2)
			inOut: (t) ->
				t *= 2
				return if t < 1 then 0.5 * t*t else t -= 1 ; -0.5 * (t * (t - 2) - 1)
			outIn: (t) ->
				return if t < 0.5 then Easing.quadratic.out(t * 2) * 0.5
				else Easing.quadratic.in(t * 2 - 1) * 0.5 + 0.5
		cubic:
			in:    (t) -> t*t*t
			out:   (t) -> t -= 1 ; t*t*t + 1
			inOut: (t) ->
				t *= 2
				return if t < 1 then 0.5 * t*t*t else t -= 2 ; 0.5 * (t*t*t + 2)
			outIn: (t) ->
				return if t < 0.5 then Easing.cubic.out(t * 2) * 0.5
				else Easing.cubic.in(t * 2 - 1) * 0.5 + 0.5
		quartic:
			in:    (t) -> t*t*t*t
			out:   (t) -> t -= 1 ; -(t*t*t*t - 1)
			inOut: (t) ->
				t *= 2
				return if t < 1 then 0.5 * t*t*t*t else t -= 2 ; -0.5 * (t*t*t*t - 2)
			outIn: (t) ->
				return if t < 0.5 then Easing.quartic.out(t * 2) * 0.5
				else Easing.quartic.in(t * 2 - 1) * 0.5 + 0.5
		quintic:
			in:    (t) -> t*t*t*t*t
			out:   (t) -> t -= 1 ; t*t*t*t*t + 1
			inOut: (t) ->
				t *= 2
				return if t < 1 then 0.5 * t*t*t*t*t else t -= 2 ; 0.5 * (t*t*t*t*t + 2)
			outIn: (t) ->
				return if t < 0.5 then Easing.quintic.out(t * 2) * 0.5
				else Easing.quintic.in(t * 2 - 1) * 0.5 + 0.5
		sinusoidal: # y
			in:    (t) -> -Math.cos(t * Math.HALFPI) + 1
			out:   (t) ->  Math.sin(t * Math.HALFPI)
			inOut: (t) -> -0.5 * (Math.cos(t * Math.PI) - 1)
			outIn: (t) ->
				return if t < 0.5 then Easing.sinusoidal.out(t * 2) * 0.5
				else Easing.sinusoidal.in(t * 2 - 1) * 0.5 + 0.5
		exponential: # y
			in:    (t) -> return if t is 0 then 0 else  Math.pow(2, 10 * (t - 1))
			out:   (t) -> return if t is 1 then 1 else -Math.pow(2, -10 * t) + 1
			inOut: (t) ->
				return 0 if t is 0
				return 1 if t is 1
				t *= 2
				return if t < 1 then 0.5 * Math.pow(2, 10 * (t - 1))
				else 0.5 * (-Math.pow(2, -10 * (t - 1)) + 2)
			outIn: (t) ->
				return if t < 0.5 then Easing.exponential.out(t * 2) * 0.5
				else Easing.exponential.in(2 * t - 1) * 0.5 + 0.5
		circular: # y
			in:    (t) -> -(Math.sqrt(1 - t*t) - 1)
			out:   (t) -> t -= 1 ; Math.sqrt(1 - t*t)
			inOut: (t) ->
				t *= 2
				return if t < 1 then -0.5 * (Math.sqrt(1 - t*t) - 1)
				else t -= 2 ; 0.5 * (Math.sqrt(1 - t*t) + 1)
			outIn: (t) ->
				return if t < 0.5 then Easing.circular.out(t * 2) * 0.5
				else Easing.circular.in(t * 2 - 1) * 0.5 + 0.5
		###arctangent:
			in:    (t) ->
			out:   (t) ->
			inOut: (t) ->
			outIn: (t) ->
		bounce:
			in:    (t) ->
			out:   (t) ->
			inOut: (t) ->
			outIn: (t) ->
		back:
			in:    (t) ->
			out:   (t) ->
			inOut: (t) ->
			outIn: (t) ->
		elastic:
			in:    (t) ->
			out:   (t) ->
			inOut: (t) ->
			outIn: (t) ->###
