Number.isNumber = (object) -> toString.call(object) is '[object Number]'

Number::abs = -> Math.abs @
Number::chr = -> String.fromCharCode @

Number::odd  = ->     @ & 1
Number::even = -> not @ & 1

Number::ceil  = -> Math.ceil  @
Number::floor = -> Math.floor @
Number::round = -> Math.round @

Number::times = (iter) ->
	i = 0
	n = this.abs()
	while i < n then iter(i++)

Number::upto = (to, iter) ->
	return false if to < @
	item = @; index = to - @
	while index-- then iter(item++)

Number::downto = (to, iter) ->
	return false if to > @
	item = @; index = @ - to
	while index-- then iter(item--)

Number::random = -> (rand * @).round()
