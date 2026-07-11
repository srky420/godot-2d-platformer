extends State

# Assign other states
@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State

# Attack and combo cooldowns
@export var attack_cooldown: Timer
@export var combo_cooldown: Timer

# Combo counter
var combo_counter: int = 0

# AnimationTree reference
var playback: AnimationNodeStateMachinePlayback

# Start cooldowns and play Attack1 anim
func enter(prev_state: State) -> void:
	playback = parent.get_node("AnimationTree")["parameters/playback"]
	playback.travel("Attack1")
	attack_cooldown.start()
	combo_cooldown.start()
	
func physics_process(delta: float) -> void:
	# Don't allow state swich if player is attacking
	if is_attacking():
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
		return
		
	# Transition to jump
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to(jump_state)
		return

# Return attacking state based on cooldowns
func is_attacking() -> bool:
	if attack_cooldown.is_stopped() and not combo_cooldown.is_stopped():
		if Input.is_action_just_pressed("attack"):
			playback.travel("Attack2")
			attack_cooldown.start()
			combo_cooldown.start()
			return true
	
	if attack_cooldown.is_stopped() and combo_cooldown.is_stopped():
		return false
	
	return true
