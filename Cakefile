fs   = require 'fs'
sys  = require 'sys'
path = require 'path'

{exec, spawn}          = require 'child_process'
{puts, print, inspect} = require 'util'

###
	Path Configuration
###
pids = path.join __dirname, '.pid/'
logs = path.join __dirname, 'log/'
code =
	lib: path.join __dirname, 'lib/'
	src: path.join __dirname, 'src/'
spec =
	lib: path.join __dirname, 'spec/lib/'
	src: path.join __dirname, 'spec/src/'

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

isPidFile = (name) ->
	path.existsSync path.join pids, "#{name}.pid"

readPidFile = (name) ->
	if isPidFile name
		return fs.readFileSync path.join(pids, "#{name}.pid"), 'utf8'
	return false

writePidFile = (name, processId) ->
	fs.writeFileSync path.join(pids, "#{name}.pid"), "#{processId}", 'utf8'

removePidFile = (name) ->
	fs.unlinkSync path.join pids, "#{name}.pid"

cleanLogFile = (name) ->
	fs.writeFileSync path.join(logs, "#{name}.log"), "", 'utf8'

startWatcher = (name, opts = {}) ->
	return if not name?
	return false if isPidFile name

	opts.lib = opts.lib or 'lib/'
	opts.src = opts.src or 'src/'
	opts.log = opts.log or "#{name}.log"
	opts.cmd = opts.cmd or "coffee -c -b -w -o #{opts.lib} #{opts.src}"

	opts.cmd += " >> #{logs}#{opts.log} 2>&1" if true #shouldLog
	opts.cmd += " & echo $!"
	console.log "command - #{opts.cmd}"
	exec opts.cmd, cwd: __dirname, (error, stdout, stderr) ->
		if error
			console.log "Error running coffee: #{stderr}"
		else
			console.log "Watcher '#{name}' (pid=#{stdout.trim()}) has been started."
			writePidFile name, stdout.trim()

stopWatcher = (name) ->
	if not isPidFile name
		console.log "Watcher '#{name}' is not running."
		return
	pid = readPidFile name
	return false if pid is false
	exec "kill -9 #{pid}", (error, stdout, stderr) ->
		if error
			puts stderr
		else
			console.log "Watcher '#{name}' (pid=#{pid}) has been stopped."
			removePidFile name
			cleanLogFile name

listWatcher = (name) ->
	if isPidFile name
		pid = parseInt readPidFile name
		exec "ps -x | grep #{pid} | grep -v grep", (error, stdout, stderr) ->
			puts stderr if error
			out = stdout.split /\s+/
			print "#{name}\t\t#{pid}\t\t"
			puts out.slice(3).join ' '
	else
		puts "#{name}\t\toffline\t\t-------"

task 'watch:start', 'Watch all the things.', ->
	startWatcher 'code'
	startWatcher 'spec', lib: 'spec/lib/', src: 'spec/src/'

task 'watch:stop', 'Un-watch all the things.', ->
	stopWatcher 'code'
	stopWatcher 'spec'

task 'watch:list', 'List running watchers.', ->
	puts "NAME\t\tPROCESS\t\tCOMMAND"
	listWatcher 'code'
	listWatcher 'spec'

task 'watch:code', 'Toggle code watching.', ->
	stopWatcher 'code' if false is startWatcher 'code'

task 'watch:spec', 'Toggle spec watching.', ->
	stopWatcher 'spec' if false is startWatcher 'spec', lib: 'spec/lib/', src: 'spec/src/'


task 'spec:web', 'Run the tests in a browser.', ->
	exec 'open "http://localhost/Private/JS/MotionJS/spec/runner.html"'

task 'spec:cli', 'Run the tests on the command-line.', ->
	test = spawn 'npm', ['test'], cwd: __dirname
	test.stderr.setEncoding 'utf8'
	test.stdout.setEncoding 'utf8'
	test.stdout.on 'data', (data) -> print data
	test.stderr.on 'data', (data) -> print data


task 'compile:spec', 'Compile the tests.', ->
	return if isPidFile 'spec'
	print "Cleanup lib (#{spec.lib}) .."
	exec "rm -rf #{spec.lib}*", ->
		puts '.done!'
		print "Compile src (#{spec.src}) .."
		brew '-c -b -o spec/lib/ spec/src/', onexit: ->
			puts '.done!'

task 'compile:code', 'Compile the code.', ->
	return if isPidFile 'code'
	print "Cleanup lib (#{code.lib}) .."
	exec "rm -rf #{code.lib}*", ->
		puts '.done!'
		print "Compile src (#{code.src}) .."
		brew '-c -b -o spec/lib/ spec/src/', onexit: ->
			puts '.done!'


task 'clean', 'Clean. EVERYTHING.', ->
	invoke 'clean:logs'
	invoke 'clean:pids'

task 'clean:logs', 'Clean log files.', ->
	exec "rm -rf #{logs}*.log"

task 'clean:pids', 'Clean pid files.', ->
	exec "rm -rf #{pids}*.pid"


task 'sbuild', 'For building from Sublime', ->
	invoke 'compile:code'
	invoke 'compile:spec'
