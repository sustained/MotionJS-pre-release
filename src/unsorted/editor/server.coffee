#
require [
	'fs'
	'sys'
	'http'
	'socket.io'
], (fs, sys, http, io) ->
	motionUrl  = 'http://localhost:80/Shared/JavaScript/MotionJS/'
	motionPath = '/Library/WebServer/Documents/Shared/JavaScript/MotionJS/'

	server = http.createServer()
	server.listen 8080

	socket = io.listen server

	socket.on 'connection', (client) ->
		console.log "server got client #{client}"

		client.on 'message', (message) ->
			console.log "message #{message} from #{client}"

		client.on 'disconnect', ->
			console.log "client #{client} disconnected"
