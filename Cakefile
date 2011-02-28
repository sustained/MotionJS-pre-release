fs            = require 'fs'
{puts, print} = require 'util'
path          = require 'path'
CoffeeScript  = require 'coffee-script'
{exec, spawn} = require 'child_process'

enableStdin = (onData) ->
	process.stdin.resume()
	process.stdin.setEncoding 'utf8'
	process.stdin.on 'data', onData

spawnCoffee = (options) ->
	coffee  = spawn "coffee", options.split(' '), cwd: __dirname
	
	coffee.stdout.setEncoding 'utf8'
	coffee.stderr.setEncoding 'utf8'
	coffee.stdout.on 'data', (data) -> puts data.trim()
	coffee.stderr.on 'data', (data) -> puts data.trim()
	
	coffee

task 'compile', '...', ->
	spawnCoffee '--compile --bare --output lib/ src/'
	
task 'watch', 'Auto-compile files when they are modified.', ->
	coffee = spawnCoffee '--compile --bare --watch --output lib/ src/'
	
	enableStdin (io) ->
		if io.trim() in ['update', 'restart']
			puts 'Auto-compiling restarting...'
			coffee.kill 'SIGKILL'
			coffee = watchAndCompile()
		true