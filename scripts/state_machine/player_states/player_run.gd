extends State

# Player speed
@export var speed: float

# Other state references
@export var idle_state: State
@export var fall_state: State
@export var jump_state: State
@export var attack_state: State

func physics_process(delta: float) -> void:
	# Apply gravity and movement
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	
	# Movemeent based on direction
	var direction := Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * speed
	parent.move_and_slide()
	if parent.has_node("Sprite2D") and direction != 0.0:
		parent.get_node("Sprite2D").flip_h = direction < 0.0
		
	# Transition to fall state
	if not parent.is_on_floor():
		state_machine.transition_to(fall_state)
		return
		
	# Transition to idle state
	if direction == 0:
		state_machine.transition_to(idle_state)
		return
		
	# Transition to jump state
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to(jump_state)
		return
		
	# Transition to attack state
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to(attack_state)
		return
	
	
	
	
	
