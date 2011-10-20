#
define [
	'path'
	'server/file'
], (path, File) ->
	class Directory
		sync:  false
		cache: null

		_exists: false

		setup: ->


		toString: ->
			@dir

		constructor: (dir) ->
			@setDirectory dir

		setDirectory: (dir) ->
			if @_exists = path.existsSync dir
				dir += '/' if dir.substr -1 isnt '/'
				@dir = dir
				@setup()
				@
			false

		to: (dir, morph = false) ->
			dir = path.resolve @dir, dir
			console.log "moving from #{@dir} to #{dir}"
			if morph
				return @setDirectory dir
			else
				return new Directory dir

		up: (morph = false) ->
			@to '../', morph

		exists: ->
			@_exists

		children: (options) ->


		files: (options) ->
			return false if not @exists()

			options = $M.extend {
				recursive: false
			}, options

			fs.readdirSync @dir

		directories: (options) ->



	Directory

###
dir = new Directory '~/BlobsGame'

console.log dir
> /Users/Xavura/BlobsGame/

dir.files()
> [
>	'.motiongame'
> ]

dir.directories()
> [
>	'assets/'
>	'config/'
>	'levels/'
>	'lib/'
>	'src/'
> ]

dir.children()
> [
>	'.motiongame'
>	'assets/'
>	'config/'
>	'levels/'
>	'lib/'
>	'src/'
> ]

dir.to('src/entities').files()
> [
>	'player.coffee'
>	'enemy.coffee'
> ]

dir.to('src/entities').files recursive:true
> [
>	'player.coffee'
>	'enemy.coffee'
>	'weapons/grenade.coffee'
>	'weapons/firearm.coffee'
> ]

dir.to('src/entities', true)
console.log dir
> /Users/Xavura/BlobsGame/src/entities/

dir.files extension: '.js'
> []

dir.files(match:/^weapons\/.*$/, fetch:true).each (file) ->
	console.log file, file.contents 'utf8'

> /Users/Xavura/BlobsGame/src/entities/weapons/grenade.coffee
> /Users/Xavura/BlobsGame/src/entities/weapons/firearm.coffee
###
