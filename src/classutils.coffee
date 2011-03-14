define ->
	ClassUtils =
		Inc: {}
		
		Ext:
			Aliasing:
				alias: (aliases, method) ->
					if isArray aliases
						@::[i] = method for i in aliases
					else
						@::[aliases] = method
			
			Accessors:
				set: (name, set, options = {}) ->
					options = Motion.ext {enumerable: true, configurable: true}, options
					Object.defineProperty @::, name, Motion.ext options, set: set
				
				get: (name, get, options = {}) ->
					options = Motion.ext {enumerable: true, configurable: true}, options
					Object.defineProperty @::, name, Motion.ext options, get: get
	
	ClassUtils