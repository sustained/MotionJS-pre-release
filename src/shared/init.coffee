reqOpts    = {}
isBrowser  = window? and document? and navigator?
rootObject = if isBrowser then window else global

rootObject.Motion      = _fake: true
rootObject.Motion.init = (options = {}) ->
	appDir = options.appDir
	modDir = options.modDir
	sysDir = options.sysDir

	if not appDir or not sysDir
		return console.error '[Motion.init] Missing required options appDir and/or sysDir.'
	
	reqOps = 
		baseUrl: "#{sysDir}lib/"
		deps: []
		paths:
			app: "#{appDir}lib"
			npm: "#{sysDir}node_modules"
			dep: "#{sysDir}dep"
		priority: [
			'shared/natives/array'
			'shared/natives/function'
			'shared/natives/math'
			'shared/natives/number'
			'shared/natives/object'
			'shared/natives/regexp'
			'shared/natives/string'
			'shared/core'
		]

	reqOps.paths.mod = "#{modDir}lib/" if modDir?

	if isBrowser
		reqOps.priority.unshift 'dep/jquery/jquery'

		# node api stuff
		reqOps.paths.fs   = 'client/node/fs'
		reqOps.paths.path = 'client/node/path'

		if options.cacheBust?
			reqOps.urlArgs = "nocache=#{(new Date()).getTime()}"
	
	reqOps
