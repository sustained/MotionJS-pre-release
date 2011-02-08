client = (Eventful) ->
	class Client
		constructor: (@connection, @server) ->
			@id = connection.sessionId
			
			@Event = new Eventful ['message', 'close', 'rejected'], binding: @
			
			connection.addListener 'message', (data) ->
				console.log data
			
			connection.addListener 'disconnect', ->
				console.log "Client #{@id} disconnected"
		
		send: (command, data) ->
			@client.send [command, data]
	
	Client

define ['eventful'], client