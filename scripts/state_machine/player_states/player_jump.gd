extends State

# Assign statees
@export var idle_state: State
@export var run_state: State
@export var fall_state: State

@export var air_speed: float
@export var jump_force: float

func enter(prev_state: State) -> void:
	parent.velocity.y = jump_force


func physics_process(delta: float) -> void:
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	
	# Air movemeent based on direction
	var direction := Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * air_speed
	parent.move_and_slide()
	if parent.has_node("Sprite2D") and direction != 0.0:
		parent.get_node("Sprite2D").flip_h = direction < 0.0
	
	# Transition to fall state
	if parent.velocity.y >= 0.0:
		state_machine.transition_to(fall_state)
		return
		
	# Transition to fall state when hit on ceiling
	if parent.is_on_ceiling():
		parent.velocity.y = 0.0
		state_machine.transition_to(fall_state)
		return
		
