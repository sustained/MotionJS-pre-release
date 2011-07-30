define ['shared/core'], ->
	module 'Eventful'

	test "Motion.Event?", -> ok Motion.Event?

	_defBinding = one: 1, two: 2
	_newBinding = foo: 1, bar: 2
	_event      = new Motion.Event 'evt', binding: _defBinding

	# shortcuts
	event = _event.on.bind    _event, 'evt'
	after = _event.after.bind _event, 'evt'
	fire  = _event.fire.bind  _event, 'evt'
	clear = _event.clear.bind _event, 'evt'

	test "Callback args from on() & fire() should work both independently and simultaneously.", ->
		event ( (foo) ->
			equal foo, 'foo', 'the callbacks argument should be foo'
		), args: ['foo']
		fire()
		clear()

		event (bar) -> equal bar, 'bar', 'the callbacks argument should be bar'
		fire ['bar']
		clear()

		event ( (a, b) ->
			equal a, 42,  'the callbacks 1st argument should be 42'
			equal b, 420, 'the callbacks 2nd argument should be 420'
		), args: [42]
		fire [420]
		clear()

	test "Callback binding.", ->
		event ->
			strictEqual @, _defBinding, "the callback should be bound to _defBinding"
		fire()
		clear()

		event ( ->
			strictEqual @, _newBinding, "the callback should be bound to _newBinding"
		), bind: _newBinding
		fire()
		clear()

	test "One-time callbacks.", ->
		increments = 0

		event (-> increments++), once: true
		fire() for i in [0...5]

		equal increments, 1, "the callback should have been called just once"
		equal _event.events.evt.length, 0, "the callback should be gone now"

		clear()

	test "Event limits.", ->
		increments = 0

		_event.setOptions 'evt', limit: 3
		equal _event.eventOptions.evt.limit, 3, "the fire limit for the event should be 3"

		event -> increments++
		#after -> equal increments, 3, "event should not fire more times than the limit"
		fire() for i in [0...5]

		equal increments, 3, "the event should not have fired more than the limit"
		equal _event.isEvent('evt'), false, "does the event still exist"
		equal _event.isEvent('after_evt'), false, "does the after_event exist"

		clear()
