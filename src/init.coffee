isBrowser = window? and document? and navigator?
root      = if isBrowser then window else global

root.motion = (sysDir, paths = {}, readyFn) ->
	return console.error '[Motion:init] Missing required sysDir.' if not sysDir

	readyFn = paths if _.isFunction paths
	reqOps =
		#context: "motion"
		baseUrl: "#{sysDir}lib/"
		deps: ['core']
		paths:
			dep: "#{sysDir}vendor"
		ready: readyFn

	reqOps.paths[k] = v for k,v of paths

	if isBrowser
		reqOps.paths.fs   = 'client/node/fs'
		reqOps.paths.path = 'client/node/path'

		reqOps.urlArgs = "nocache=#{(new Date()).getTime()}" #if options.cacheBust?

	reqOps
