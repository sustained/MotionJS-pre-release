fs   = require 'fs'
sys  = require 'sys'
path = require 'path'

code =
	lib: path.join __dirname, 'lib/'
	src: path.join __dirname, 'src/'
spec =
	lib: path.join __dirname, 'test/lib/'
	src: path.join __dirname, 'test/src/'

{exec, spawn}          = require 'child_process'
{puts, print, inspect} = require 'util'

brew = (options, callbacks = {}) ->
	coffee = spawn 'coffee', options.split(' '), cwd: __dirname

	coffee.stdout.setEncoding 'utf8'
	coffee.stderr.setEncoding 'utf8'
	coffee.stdout.on 'data', callbacks.stdout or (data) -> puts data.trim()
	coffee.stderr.on 'data', callbacks.stderr or (data) -> puts "stderr: #{data.trim()}"
	coffee.on 'exit',        callbacks.onexit or -> null
	
	coffee

task 'spec:run', 'Run the tests.', ->
	print 'Opening Web Browser... '
	exec 'open "http://localhost/Private/JS/MotionJS/test/runner.html"', -> puts 'done!'

task 'spec:compile', 'Compile the tests.', ->
	puts '[Building spec]'
	puts "$lib = #{spec.lib}"
	puts "$src = #{spec.src}\n"
	print 'Cleaning lib directory... '

	exec "rm -rf #{spec.lib}*", ->
		puts 'done!'
		print 'Compiling src directory... '
		brew '--compile --bare --output test/lib/ test/src/', onexit: -> puts 'done!'

task 'spec:watch', 'Auto-compile the tests.', ->
	brew '--compile --bare --watch --output test/lib/ test/src/'

task 'code:compile', 'Compile the code.', ->
	puts '[Building code]'
	puts "$lib = #{code.lib}"
	puts "$src = #{code.src}\n"
	print 'Cleaning lib directory... '

	exec "rm -rf #{code.lib}*", ->
		puts "done!"
		print "Compiling src directory... "
		brew '--compile --bare --output lib/ src/', onexit: -> puts "done!"

task 'code:watch', 'Auto-compile the code.', ->
	brew '--compile --bare --watch --output lib/ src/',
		stdout: (data) ->
			data = data.trim()
			if data.indexOf('In') is 0
				exec "growlnotify -a 'iTerm2' -m '#{data}' -t 'Compile Error'"
			puts data

task 'code:build', 'Build the code.', ->
	
