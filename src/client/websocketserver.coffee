#
server = (Eventful) ->
	class Server extends Class
		@ReconnectAttempts: 5
		@ReconnectInterval: 10000
		@State:
			Null:         0
			Connecting:   1
			Connected:    2
			Disconnected: 3
			Reconnecting: 4
			Offline:      5

		opens:    0
		closes:   0
		attempts: 0

		state:     @State.Null
		socket:    null
		connected: no

		autoReconnect: on

		constructor: (@host = 'ws://localhost:8080/') ->
			super()

			@Event = new Eventful [
				'connecting'
				'connected'
				'reconnecting'
				'reconnected'
				'disconnected'
				'offline'
				'message'
			], binding: @

			@Event.add "msg.#{i}" for i in [
				'uuid'
				'loginReceived'
				'loginSuccess'
				'loginFailure'
			]

		send: (message, data) ->
			@socket.send JSON.stringify [message, data]

		_onSocketOpen: ->
			@opens++
			@Event.fire 'connected'
			@Event.fire 'reconnected' if @state is Server.Reconnecting
			@state = Server.State.Connected

		_onSocketClose: ->
			@closes++
			@state = Server.State.Disconnected

			if @closes > @opens
				console.log "Server #{@host} appears to be offline."
			else
				console.log "Disconnected from Server #{host}"
				@Event.fire 'disconnected'

			if @attempts < Server.ReconnectAttempts and @autoReconnect is on
				@state = Server.State.Reconnecting
				@Event.fire 'reconnecting'

				setTimeout @method('connect'), Server.ReconnectInterval
			else
				@state = Server.State.Offline
				@Event.fire 'offline'

		_onSocketError: ->
			console.log "Server error #{@host}"

		_onSocketMessage: ->
			try
				json = JSON.parse e.data
			catch e
				console.error e
				return

			message = parseInt json[0]
			data    = json[1]

			@Event.fire 'message', [message, data] # global event
			@Event.fire "#{message}Message", data  # specific event

		createSocket: ->
			@socket.close() if @isSocket()
			@socket = new WebSocket @host
			@socket.onopen    = @method '_onSocketOpen'
			@socket.onclose   = @method '_onSocketClose'
			@socket.onerror   = @method '_onSocketError'
			@socket.onmessage = @method '_onSocketMessage'
			@socket

		connect: ->
			return true if @state is Server.Connecting or @state is Server.Connected
			@createSocket()

		disconnect: ->
			socket.close() if @isSocket()

		isSocket: ->
			@socket instanceof WebSocket

		isConnected: ->
			@state is Server.State.Connected

		isConnecting: ->
			@state is Server.State.Connecting or @state is Server.State.Reconnecting

	Server

define ['eventful'], server
