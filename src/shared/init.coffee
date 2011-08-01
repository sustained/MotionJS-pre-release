isBrowser = window? and document? and navigator?
root      = if isBrowser then window else global

root.motionInit = (sysDir, apps = {}) ->
	return console.error '[Motion:init] Missing required sysDir.' if not sysDir

	reqOps =
		#context: "motion"
		baseUrl: "#{sysDir}lib/"
		deps: ['shared/core']
		paths:
			dep: "#{sysDir}vendor"

	reqOps.paths[k] = "#{v}lib/" for k,v of apps

	if isBrowser
		reqOps.paths.fs   = 'client/node/fs'
		reqOps.paths.path = 'client/node/path'

		reqOps.urlArgs = "nocache=#{(new Date()).getTime()}" #if options.cacheBust?

	reqOps
