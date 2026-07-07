extends State

# Assign states
@export var idle_state: State
@export var run_state: State
@export var jump_state: State

# Air movement
@export var air_speed: float

func physics_process(delta: float) -> void:
	# Apply gravity and air movement
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	var direction = Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * air_speed
	parent.move_and_slide()
	
	# Transition to idle or run
	if parent.is_on_floor():
		if direction != 0:
			state_machine.transition_to(run_state)
		else:
			state_machine.transition_to(idle_state)
	
	
