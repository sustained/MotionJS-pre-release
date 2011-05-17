define ->
	{Eventful}  = Motion
	_defBinding = one:1, two:2, three:3
	_newBinding = foo:1, bar:2, baz:3

	event = new Eventful 'evt', binding: _defBinding

	module 'Eventful'

	test "Callback arguments.", ->
		event.on 'evt', ((a, b) ->
			equal a,  42, '1st argument from on() should be present'
			equal b, 420, '2nd argument from fire() should be present'
		), args: [42]
		event.fire 'evt', [420]
		event.clear 'evt'

	test "Callback binding.", ->
		event.on 'evt', ->
			strictEqual @, _defBinding, 'callback should be bound to the default binding'
		event.fire  'evt'
		event.clear 'evt'

		event.on 'evt', (->
			strictEqual @, _newBinding, 'callback should be bound to the callback-specific binding'
		), bind: _newBinding
		event.fire 'evt'
		event.clear 'evt'
	
	test "One-time callbacks.", ->
		increments = 0

		event.on 'evt', (-> increments++), once: true
		event.fire 'evt' for i in [0...5]

		equal increments, 1, "callback should only be called once"
		equal event.events.evt.length, 0, "callback should have been removed afterwards"

		event.clear 'evt'
	
	test "Event limits.", ->
		increments = 0

		event.setOptions 'evt', limit: 3
		equal event.eventOptions.evt.limit, 3, "the events limit should be set"

		event.on    'evt', -> increments++
		event.after 'evt', -> equal increments, 3, "event should not fire more times than the limit"
		event.fire  'evt' for i in [0...5]

		equal event.isEvent('evt'), false, "event should have been removed afterwards"
		equal event.isEvent('after_evt'), false, "after_event should have been removed too"

		event.clear 'evt'
