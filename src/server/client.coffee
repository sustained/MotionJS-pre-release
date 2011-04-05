define ['eventful'], (Eventful) ->
	class Client
		log: (message) ->
			console.log "Client ##{@id}: #{message}"
		
		constructor: (@connection, @server) ->
			@id    = connection.sessionId
			@event = new Eventful ['message', 'close', 'rejected'], binding: @
			
			@log 'connected'
			
			connection.addListener 'message', (message) =>
				@log "message: #{message}"
			
			connection.addListener 'disconnect', =>
				@log 'disconnected'
		
		send: (message) ->
			@connection.send message
		
		broadcast: (message) ->
			@connection.broadcast message
		
		isConnected: -> @connection.connected
	
	Client