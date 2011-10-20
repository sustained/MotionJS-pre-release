#
define ->
	{defaults, extend} = _

	class Delegator
		addDelegator: (property, methods = []) ->
			@[method] = @[property][method] for method in methods

	Utils =
		Delegator: Delegator
		Accessors:
			set: (name, set, options = {}) ->
				options = defaults options, enumerable: true, configurable: true
				Object.defineProperty @::, name, extend options, {set: set}

			get: (name, get, options = {}) ->
				options = defaults options, enumerable: true, configurable: true
				Object.defineProperty @::, name, extend options, {get: get}

	Utils
