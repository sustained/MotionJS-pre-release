class Guy extends Entity
	constructor: ->
		@addBehaviour 'walk', new WalkingAnimationBehaviour @getAnimation 'walk'
		@addBehaviour 'jump', new JumpingAnimationBehaviour @getAnimation 'jump'
		@addBehaviour 'fall', new FallingAnimationBehaviour @getAnimation 'fall'
		
		@addBehaviour 'click', new ClickBehaviour -> 
	
	update: ->
		@updateBehaviours()
	
	render: ->
		