fs   = require 'fs'
sys  = require 'sys'
path = require 'path'

$lib = path.join __dirname, 'lib/'
$src = path.join __dirname, 'src/'

{puts, print} = require 'util'
{exec, spawn} = require 'child_process'
CoffeeScript  = require 'coffee-script'

brew = (options, callbacks = {}) ->
	coffee = spawn "coffee", options.split(' '), cwd: __dirname
	
	coffee.stdout.setEncoding 'utf8'
	coffee.stderr.setEncoding 'utf8'
	coffee.stdout.on 'data', callbacks.stdout ? (data) -> puts data.trim()
	coffee.stderr.on 'data', callbacks.stderr ? (data) -> puts "stderr: #{data.trim()}"
	coffee.on 'exit',        callbacks.onexit ? -> null
	
	coffee

task 'build', 'Build MotionJS.', ->
	brew '--compile --bare --output lib/ src/'

task 'watch', 'Auto-compile anything in src/ to lib/ when modified.', ->
	brew '--compile --bare --watch --output lib/ src/'