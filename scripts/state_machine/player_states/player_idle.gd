extends State

# Other state references
@export var run_state: State
@export var fall_state: State
@export var jump_state: State
@export var attack_state: State

# Entry
func enter(prev_state: State) -> void:
	parent.velocity.x = 0.0


func physics_process(delta: float) -> void:
	# Add the gravity and movement
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	parent.move_and_slide()
	
	# Transition to run state
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.transition_to(run_state)
		return
	
	# Transition to fall state
	if not parent.is_on_floor():
		state_machine.transition_to(fall_state)
		return
	
	# Transition to jump state
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to(jump_state)
		return
		
	# Transition to attack state
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to(attack_state)
		return
