define ->
	Utils =
		Accessors:
			set: (name, set, options = {}) ->
				options = Object.extend {enumerable: true, configurable: true}, options
				Object.defineProperty @::, name, Object.extend options, {set: set}
			
			get: (name, get, options = {}) ->
				options = Object.extend {enumerable: true, configurable: true}, options
				Object.defineProperty @::, name, Object.extend options, {get: get}
	
	Utils
