###
InputDevice -
	Keyboard
	Mouse
	Touch
	Kinect
	... more?

Input.constructor ->
	@_actionKeys = ['']

	if Input.isTouchScreen()
		@update = @_updateTouch
	else
		@update = =>
			@_updateKeyboard()
			@_updateMouse()

Input._updateKeyboard ->
	for i in @_actionKeys

                 #ns.actionName     #kbAction    #touchAction
Input.addAction 'main.moveNorth', ['kb.held.w', 'ts.held.moveNorth'], (e) ->
	if e.life > 0.2
		@anim   = @anims[if e.shift then 'run' else 'walk'].n
		@facing = @movement = MOVEMENT.left
	else if @facing isnt MOVEMENT.left
		@anim.reset()
		@anim = @animations.walk.left
		@facing = MOVEMENT.left

Input.addAction 'main.moveSouth', 's'
Input.addAction 'main.moveEast',  'e'
Input.addAction 'main.moveWest',  'w'
Input.addAction 'main.moveMouse', 'm'

Input.add 'console', '`'
Input.add 'frameRate', ['f', 'ctrl']


class StateMain extends Screen
	enable:  -> Input.enable  'main'
	disable: -> Input.disable 'main'

	input: (Input) ->
		if Input.action 
if Input.key('a', [])

###

define [
	'client/input/keyboard'
	'client/input/mouse'
	'client/input/touch'
], (Keyboard, Mouse, Touch) ->
	class Input
		@TOUCH_DEVICE: Modernizr.touch

		_actions: null

		constructor: (opt) ->
			if opt.devices
				@addDevice i for i in opt.devices
			else if Input.TOUCH_DEVICE
				@addDevice TouchPad
			else
				@addDevice Keyboard
				@addDevice Mouse

			@_actions =
				default: {}

		isAction: (name, group = 'default') ->
			group of @_actions and name of @_actions[group]

		addDevice: (device) ->
			

		enableDevice:  (device) ->
		disableDevice: (device) ->

		addAction: (name, actions, callback) ->
			if name.indexOf('.') is -1
				group = 'default'
			else
				[name, group] = name.split '.'
			
			actions = [actions] if not _.isArray actions

			@_actions[group][name] = [] if not isAction name, group
			for i in actions
				[device, action, key] = i.split '.'
