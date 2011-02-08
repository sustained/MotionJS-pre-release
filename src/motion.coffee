isBrowser = window? and document? and navigator?

Motion =
	env: if isBrowser then 'client' else 'server'
	root: if isBrowser then window else global
	version: '0.1'

define [
	'core'
	'class'
	'classutils'
	'hash'
	'math/vector'
], (Core, Class, ClassUtils, Hash, Vector) ->
	console.log Core
	
	# Global uber-shorthand methods for *really* common stuff... what?
	#root.v = root.vec2 = (i, j) -> new Vector i, j
	Motion.root.rand = Math.rand
	
	#extend root, require util if env is 'server'
	
	Motion.Class      = Class
	Motion.ClassUtils = ClassUtils
	
	Motion.Hash   = Hash
	Motion.Vector = Vector
	
	Motion