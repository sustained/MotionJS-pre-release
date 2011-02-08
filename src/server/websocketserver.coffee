server = (io, Client) ->
	class Server
		clients: null
		
		constructor: ->
			@clients = {}
		
		attach: (httpServer) ->
			return false if not httpServer instanceof http.Server
			
			@socket = io.listen httpServer
			@socket.on 'connection', (client) ->
				console.log "(WebSocket) Client #{client} connected"
				@clients[client.sessionId] = new Client client, @
			
			true
		
		send: (id, command, data = {}) ->
			@server.send id, JSON.stringify [command, data]
		@broadcast: @::send
	
	Server

define [
	'socket.io',
	'server/websocketclient'
], server