require    = {}
isBrowser  = window? and document? and navigator?
rootObject = if isBrowser then window else global

initMotion = (options = {}) ->
	appDir  = options.appDir or false
	sysDir  = options.sysDir or false

	if not appDir or not sysDir
		return console.error 'Missing options appDir and/or sysDir.'

	require = 
		baseUrl: sysDir
		deps: []
		paths:
			app:    appDir
			game:   appDir
			vendor: sysDir + '../vendor/'
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

	if isBrowser
		require.priority.unshift 'vendor/jquery/jquery'

		require.paths.fs   = 'client/node/fs'
		require.paths.path = 'client/node/path'

		if options.cacheBust?
			require.urlArgs = "nocache=#{(new Date()).getTime()}"
