define ->
	{Event}   = Motion
	{isArray} = _

	return ->
		describe 'Event', ->
			e = new Event()

			afterEach ->
				e.clear true, true
				e.binding = null

			describe 'constructor', ->
				it 'should accept an array of event names', ->
					e = new Event ['evt1', 'evt2'], binding:'test1'

					[evts, opts, names] = [e.events, e.eventOptions, e.eventNames]

					expect(evts.evt1).toBeDefined()
					expect(evts.evt2).toBeDefined()
					expect(opts.evt1).toBeDefined()
					expect(opts.evt2).toBeDefined()

					expect(names.length).toEqual 2
					expect(e.binding).toEqual 'test1'
			
				it 'should accept n strings of event names', ->
					e = new Event ['evt1', 'evt2'], binding:'test2'

					[evts, opts, names] = [e.events, e.eventOptions, e.eventNames]

					expect(evts.evt1).toBeDefined()
					expect(evts.evt2).toBeDefined()
					expect(opts.evt1).toBeDefined()
					expect(opts.evt2).toBeDefined()

					expect(names.length).toEqual 2
					expect(e.binding).toEqual 'test2'
			
			describe 'callback arguments', ->
				e.add 'evt'

				it 'on() should pass args to callbacks', ->
					e.on   'evt', ((a) -> expect(a).toEqual 'foo'), args: ['foo']
					e.fire 'evt'
			
				it 'fire() should pass args to callbacks', ->
					e.on   'evt', (a) -> expect(a).toEqual 'bar'
					e.fire 'evt', ['bar']

				it 'args from on() and fire() should work simultaneously', ->
					e.on 'evt', (a, b) ->
						expect(a).toEqual 42
						expect(b).toEqual 420
					, args: [42]
					e.fire 'evt', [420]
			
			describe 'callback binding', ->
				it 'should correctly bind callbacks', ->
					_defBinding = one: 1, two: 2
					_newBinding = foo: 1, bar: 2

					e.add 'evt'
					e.binding = _defBinding

					e.on    'evt', -> expect(@).toBe _defBinding
					e.fire  'evt'
					e.clear 'evt'

					e.on   'evt', (-> expect(@).toBe _newBinding), bind: _newBinding
					e.fire 'evt'

			it 'should fire one-time callbacks once, then remove them', ->
				increments = 0

				e.add  'evt'
				e.on   'evt', (-> increments++), once: true
				e.fire 'evt' for i in [0...5]

				expect(increments).toEqual 1
				expect(e.events.evt.length).toEqual 0

			xit 'should correctly limit events with a "fire limit", then remove them', ->
				increments = 0

				e.add 'evt', limit: 3
				expect(e.eventOptions.evt.limit).toEqual 3

				e.on   'evt', (-> increments++)
				e.fire 'evt' for i in [0...5]

				expect(increments).toEqual 3

				expect(e.isEvent 'evt').toBeFalsy()
				expect(e.isEvent 'after_evt').toBeFalsy()
