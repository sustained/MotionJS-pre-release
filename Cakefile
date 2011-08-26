fs   = require 'fs'
sys  = require 'sys'
path = require 'path'

code =
	lib: path.join __dirname, 'lib/'
	src: path.join __dirname, 'src/'
spec =
	lib: path.join __dirname, 'spec/lib/'
	src: path.join __dirname, 'spec/src/'

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

growl = (error) ->
	exec "growlnotify -m '#{error}' -t 'Compile Error'"

task 'spec:web', 'Run the tests in a browser.', ->
	exec 'open "http://localhost/Private/JS/MotionJS/spec/runner.html"'

task 'spec:cli', 'Run the tests on the command-line.', ->
	test = spawn 'npm', ['test'], cwd: __dirname
	test.stderr.setEncoding 'utf8'
	test.stdout.setEncoding 'utf8'
	test.stdout.on 'data', (data) -> puts data.trim()
	test.stderr.on 'data', (data) -> puts data.trim()

task 'spec:compile', 'Compile the tests.', ->
	puts '[Building spec]'
	puts "$lib = #{spec.lib}"
	puts "$src = #{spec.src}\n"
	print 'Cleaning lib directory... '

	exec "rm -rf #{spec.lib}*", ->
		puts 'done!'
		print 'Compiling src directory... '
		brew '--compile --bare --output spec/lib/ spec/src/', onexit: -> puts 'done!'

task 'spec:watch', 'Auto-compile the tests.', ->
	brew '--compile --bare --watch --output spec/lib/ spec/src/',
		stdout: (data) ->
			puts data = data.trim()
			growl(data) if data.indexOf('In') is 0

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
			puts data = data.trim()
			growl(data) if data.indexOf('In') is 0

task 'code:build', 'Build the code.', ->
	

task 'sbuild', 'For building from Sublime', -> invoke 'code:compile'
