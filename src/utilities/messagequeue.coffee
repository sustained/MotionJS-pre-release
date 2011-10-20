#
queue = (Eventful) ->
	class Queue
		@messages = {}

		constructor: ->


		subscribe: (ident, eventful) ->
			if not eventful instanceof Eventful
				if 'Event' of eventful
					eventful = eventful.Event
				else return false

			if not ident of @messages
				@messages[ident] = []

			for event in eventful.eventNames
				eventful.on event, (=>
					@messages[eventful.hash()] = Array::slice.call arguments
				), once: yes
			return

		get: (message) ->
			[ident, event] = message.split ':'

			if @messages[ident] and @messages[ident][event]
				message = @messages[ident][event]
				delete @messages[ident][event]
				return message

	Queue

define ['eventful'], -> queue
