define ->
	{Eventful} = Motion

	class Client
		log: (message) ->
			console.log "Client ##{@id}: #{message}"
		
		constructor: (@connection, @server) ->
			@id    = connection.id
			@event = new Eventful ['message', 'close', 'rejected'], binding: @
			
			@connection.on 'message', (message) =>
				@log "message: #{message}"
			
			@connection.on 'disconnect', =>
				@log 'disconnected'
		
		send: (message) ->
			@connection.send message
		
		broadcast: (message) ->
			@connection.broadcast message
		
		isConnected: -> @connection.connected
