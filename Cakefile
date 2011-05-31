fs   = require 'fs'
sys  = require 'sys'
path = require 'path'

$lib = path.join __dirname, 'lib/'
$src = path.join __dirname, 'src/'

CoffeeScript           = require 'coffee-script'
{exec, spawn}          = require 'child_process'
{puts, print, inspect} = require 'util'

brew = (options, callbacks = {}) ->
	coffee = spawn "coffee", options.split(' '), cwd: __dirname
	
	coffee.stdout.setEncoding 'utf8'
	coffee.stderr.setEncoding 'utf8'
	coffee.stdout.on 'data', callbacks.stdout ? (data) -> puts data.trim()
	coffee.stderr.on 'data', callbacks.stderr ? (data) -> puts "stderr: #{data.trim()}"
	coffee.on 'exit',        callbacks.onexit ? -> null
	
	coffee

task 'build', 'Build...', ->
	puts '[Building]'
	puts "$lib = #{$lib}"
	puts "$src = #{$src}\n"
	print "Cleaning  lib directory... "

	exec "rm -rf #{$lib}*", ->
		puts "done!"
		print "Compiling src directory... "
		brew '--compile --bare --output lib/ src/', onexit: -> puts "done!"

task 'watch', 'Auto-compile...', ->
	brew '--compile --bare --watch --output lib/ src/'
