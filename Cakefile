fs            = require 'fs'
{puts, print} = require 'util'
path          = require 'path'
CoffeeScript  = require 'coffee-script'
{exec, spawn} = require 'child_process'

enableStdin = (onData) ->
	process.stdin.resume()
	process.stdin.setEncoding 'utf8'
	process.stdin.on 'data', onData

watchAndCompile = ->
	options = ["--compile", "--bare", "--watch", "--output", "lib/", "src/"]
	watch   = spawn "coffee", options, cwd: __dirname, setsid: yes
	watch.stdout.setEncoding 'utf8'
	watch.stderr.setEncoding 'utf8'
	watch.stdout.on 'data', (io) -> puts io.trim()
	watch.stderr.on 'data', (io) -> puts io.trim()
	watch.on 'exit', (code, signal) -> puts "Exit #{code} #{signal}"
	watch

task 'watch', 'Auto-compile files when they are modified.', ->
	puts "Auto-compiling enabled!"
	
	watcher = watchAndCompile()
	
	enableStdin (io) ->
		if io.trim() in ['update', 'restart']
			puts 'Auto-compiling restarting...'
			watcher.kill 'SIGKILL'
			watcher = watchAndCompile()
		true