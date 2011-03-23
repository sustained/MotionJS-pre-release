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
					options = Motion.extend {enumerable: true, configurable: true}, options
					Object.defineProperty @::, name, Motion.extend options, set: set
				
				get: (name, get, options = {}) ->
					options = Motion.extend {enumerable: true, configurable: true}, options
					Object.defineProperty @::, name, Motion.extend options, get: get
	
	ClassUtils