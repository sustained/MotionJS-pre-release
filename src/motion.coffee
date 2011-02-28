define ->
	isBrowser = window? and document? and navigator?
	
	Motion =
		isBrowser: -> isBrowser
		env:  if isBrowser then 'client' else 'server'
		root: if isBrowser then  window  else  global
		
		version: '0.1'
	
	Motion