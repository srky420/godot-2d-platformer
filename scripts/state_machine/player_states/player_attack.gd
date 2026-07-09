extends State

# Assign other states
@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State

# Attack and combo cooldowns
@export var attack_cooldown: float
@export var combo_cooldown: float

# Perform attack on enter
func enter(prev_state: State) -> void:
	var playback: AnimationNodeStateMachinePlayback = parent.get_node("AnimationTree")["parameters/playback"]
	playback.travel("Attack1")
	
func physics_process(delta: float) -> void:
	# Reduce the attack cooldown by delta
	if attack_cooldown > 0:
		attack_cooldown -= delta
		return
	
	# Apply gravity
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	parent.move_and_slide()
		
	# Transition to idle or run
	var direction = Input.get_axis("move_left", "move_right")
	if parent.is_on_floor():
		if direction != 0:
			state_machine.transition_to(run_state)
			return
		else:
			state_machine.transition_to(idle_state)
			return
	else:
		state_machine.transition_to(fall_state)
		
	
	# Transition to jump
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to(jump_state)
