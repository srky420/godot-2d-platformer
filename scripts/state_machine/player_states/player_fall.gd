extends State

# Assign states
@export var idle_state: State
@export var run_state: State
@export var jump_state: State

# Air movement
@export var air_speed: float

# Coyote jump data
@export var coyote_jump_time: float
var can_coyote_jump: bool = false
var coyote_timer: float = 0.0

func enter(prev_state: State) -> void:
	# Check if last state wasn't jump and
	# Player walked off a ledge
	coyote_timer = 0.0
	if prev_state != null and prev_state != jump_state:
		coyote_timer = coyote_jump_time
		

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
			return
		else:
			state_machine.transition_to(idle_state)
			return
	
	# Transition to jump state, coyote time
	if coyote_timer > 0.0:
		coyote_timer -= delta
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to(jump_state)
			return
	
