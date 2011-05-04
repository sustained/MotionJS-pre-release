state = (Motion, Class, Eventful) ->
	###
		Game State
		
		...
	###
	
	class State extends Class
		###
			Should this state run forever?
		###
		continuous: no
		
		###
			The unix time of when the state was last enabled.
		###
		enableTime:  0
		
		###
			The unix time of when the state was last disabled.
		###
		disableTime: 0
		
		name: null
		
		constructor: (Game) ->
			super()
			
			@Game  = Game
			@Event = new Eventful 'enable', 'disable', 'load', 'unload', 'delete', binding: @
			
			@Event.on 'load', ->
				@Game.Assets.createGroup "#{@}"
				@before() if @respondTo 'before'
			
			@Event.on 'unload', ->
				@Game.Assets.removeGroup "#{@}"
				@after() if @respondTo 'after'
		
		###
			
		###
		update: (Game, tick, delta)    ->
		
		###
		
		###
		render: (Game, alpha, context) ->
		
		###
		
		###
		before: ->
		
		###
		
		###	
		after: ->
		
		loadView: (view) ->
			group = @Game.Assets.getGroup()
			@Game.Assets.setGroup @
			@Game.Assets.load {
				file: 'views/'
			}
			@Game.Assets.setGroup group
		
		loadModel: ->
			
		
	#State.include ClassUtils.hash ?
	
	class DefaultState extends State
		constructor: (Game) ->
			super Game
		
		before: ->
			@Game.Assets.load
			
		after: ->
			@Game.Assets.unload @
	
	State

define ['motion', 'class', 'eventful'], state