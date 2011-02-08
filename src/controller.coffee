controller = ->
	class Controller extends Class
		constructor: (Game) ->
			super()
			
			@Game = Game
		
		before: ->
			
		after: ->
			
		update: (tick, delta) ->
			
		render: (context) ->
			
		
	
	Controller

define -> controller

class LoginController extends Controller
	constructor: (Game) ->
		super Game
		@state = 'default'
		
		@Message = new MessageQueue
		@Message.subscribeTo @Game.Server
	
	states:
		default:
			update: (tick, delta) ->
				
						
			render: (context) ->
				
	
	before: ->
		@loadView 'login'
		@Game.Server.connect()


class LoginMainState extends State
	update: (tick, delta) ->
		if @Message.get 'Server:connect'
			null
		else if @Message.get 'Server:disconnect'
			null
	
	render: (context) ->
		
	