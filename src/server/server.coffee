define [
	'socket.io'
	'http'
	'server/client'
], (io, http, Client) ->
	class Server
		port:    null
		socket:  null
		clients: null
		
		constructor: (@port = 8080) ->
			@clients = {}
		
		attach: (httpServer) ->
			#if not httpServer instanceof http.Server
			#	return false if not isNumber @port
			#	httpServer = http.createServer (request, response) ->
			#	httpServer.listen @port
			
			@server = io.listen httpServer#, transports: [
			#'websocket', 'flashsocket', 'xhr-multipart', 'xhr-polling', 'jsonp-polling']
			
			@server.sockets.on 'connection', (client) ->
				console.log client
				
				@clients[client.id] = new Client client, @
			
			true
		
		send: (id, message) ->
			@clients[id].send message if id in @clients
		
		broadcast: (message, except) ->
			@server.broadcast message, except
