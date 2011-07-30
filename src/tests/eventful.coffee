define ['shared/core'], ->
	{isArray} = _
	{Event} = Motion

	module 'Eventful',
		setup:    ->
			@e     = new Event 'evt'
			@is    = (event) => @e.isEvent event
			@add   = (name, opts) => @e.add name, opts
			@bind  = (bind) => @e.binding = bind
			@call  = @e.on.bind    @e, 'evt'
			@after = @e.after.bind @e, 'evt'
			@fire  = @e.fire.bind  @e, 'evt'
			@clear = @e.clear.bind @e, 'evt', true

		teardown: -> @clear() ; @e = null

	test "Sanity", ->
		ok Motion.Event?, 'Motion.Event should be defined'

	test "Constructing and adding events", ->
		ok true, 'testing new Event(arg1, ..., argN, options)'

		@e = null
		@e = new Event 'evt1', 'evt2', {}

		ok @e.events.evt1?, 'events.evt1 should exist'
		ok @e.events.evt2?, 'events.evt2 should exist'
		ok @e.eventOptions.evt1?, 'eventOptions.evt1 should exist'
		ok @e.eventOptions.evt2?, 'eventOptions.evt2 should exist'

		equal @e.eventNames.length, 2, 'eventNames.length should be 2'

		@e = null
		@e = new Event ['evt1', 'evt2'], {}

		ok true, 'testing new Event([arg1, ..., argN], options)'

		ok @e.events.evt1?, 'events.evt1 should exist'
		ok @e.events.evt2?, 'events.evt2 should exist'
		ok @e.eventOptions.evt1?, 'eventOptions.evt1 should exist'
		ok @e.eventOptions.evt2?, 'eventOptions.evt2 should exist'

		equal @e.eventNames.length, 2, 'eventNames.length should be 2'

	test "Callback arguments", ->
		ok true, 'testing independently'

		@call (a) ->
			equal a, 'foo', 'args[0] from on() should be foo'
		, args: ['foo']
		@fire()

		@clear()

		@call (a) -> equal a, 'bar', 'args[0] from fire() should be bar'
		@fire ['bar']

		@clear()

		ok true, 'testing together'

		@call (a, b) ->
			equal a, 42,  'args[0] from on() should be 42 ...'
			equal b, 420, 'and args[1] from fire() should be 420'
		, args: [42]
		@fire [420]

	test "Callback binding.", ->
		_defBinding = one: 1, two: 2
		_newBinding = foo: 1, bar: 2

		@bind _defBinding
		@clear()
		@add 'evt'

		@call -> strictEqual @, _defBinding, "callback should be bound to default"
		@fire()

		@clear()

		@call ->
			strictEqual @, _newBinding, "callback should be bound to binding from on()"
		, bind: _newBinding
		@fire()

		@bind null

	test "One-time callbacks.", ->
		increments = 0

		@call (-> increments++), once: true
		@fire() for i in [0...5]

		equal increments, 1, "callback should only fire once"
		equal @e.events.evt.length, 0, "and it should have been removed after"

	test "Event limits.", ->
		increments = 0

		@e.setOptions 'evt', limit: 3
		equal @e.eventOptions.evt.limit, 3, "the fire limit for the event should be 3"

		@call -> increments++
		#after -> equal increments, 3, "event should not fire more times than the limit"
		@fire() for i in [0...5]

		equal increments, 3, "the event should not have fired more than the limit"
		equal @is('evt'), false, "event should not exist anymore"
		equal @is('after_evt'), false, "nor should after_event"
