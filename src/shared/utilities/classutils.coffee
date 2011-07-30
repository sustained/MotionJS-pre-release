define ->
	{defaults, extend} = _

	Utils =
		Accessors:
			set: (name, set, options = {}) ->
				options = defaults options, enumerable: true, configurable: true
				Object.defineProperty @::, name, extend options, {set: set}

			get: (name, get, options = {}) ->
				options = defaults options, enumerable: true, configurable: true
				Object.defineProperty @::, name, extend options, {get: get}

	Utils
