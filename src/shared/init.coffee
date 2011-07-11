isBrowser = window? and document? and navigator?
root      = if isBrowser then window else global

root.Motion      = _fake: true
root.Motion.init = (options = {}) ->
	appDir = root.Motion.appDir = options.appDir
	modDir = root.Motion.modDir = options.modDir
	sysDir = root.Motion.sysDir = options.sysDir

	if not appDir or not sysDir
		return console.error '[Motion.init] Missing required options appDir and/or sysDir.'
	
	reqOps =
		#context: "motion"
		baseUrl: "#{sysDir}lib/"
		deps: []
		paths:
			app: "#{appDir}lib"
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
		reqOps.priority.unshift 'dep/jquery/jquery.datalink'
		reqOps.priority.unshift 'dep/jquery/jquery.tmpl'
		reqOps.priority.unshift 'dep/jquery/jquery'

		# node api stuff
		reqOps.paths.fs   = 'client/node/fs'
		reqOps.paths.path = 'client/node/path'

		if options.cacheBust?
			reqOps.urlArgs = "nocache=#{(new Date()).getTime()}"
	
	reqOps
