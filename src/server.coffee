run = (Motion, http, Server) ->
	server = http.createServer (request, response) ->
		response.writeHead 200, 'Content-Type': 'text/html'
		response.end '<h1>Hello World</h1>'

	server.listen 8080
	
	wss = new Server
	wss.attach server

require [
	'motion'
	'http'
	'server/websocketserver'
], run