define ->
	StringUtils =
		# Given a string - "foo.bar.baz", returns object['foo']['bar']['baz']
		resolveDotPath: (string, object) ->
			string   = string.split '.'
			resolved = object
			while (part = string.shift())?
				if resolved[part]? then resolved = resolved[part] else break
			resolved
