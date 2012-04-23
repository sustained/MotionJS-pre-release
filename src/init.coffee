isBrowser    = window? and document? and navigator?
{isFunction} = _

root  = if isBrowser then window else global
setup = (sysDir, paths = {}, readyFn = ->) ->
	return console.error '[Motion:init] Missing required sysDir.' if not sysDir

	if isFunction paths
		readyFn = paths
		paths   = {}

	reqOps =
		baseUrl: "#{sysDir}lib/"
		deps: ['core']
		paths:
			dep: "#{sysDir}vendor"
		callback: readyFn

	reqOps.paths[k] = "#{v}/lib" for k,v of paths

	if isBrowser
		#reqOps.paths.fs   = 'client/node/fs'
		#reqOps.paths.path = 'client/node/path'

		reqOps.urlArgs = "nocache=#{(new Date()).getTime()}" #if options.cacheBust?

	reqOps

(if isBrowser then window else exports).motion = setup
