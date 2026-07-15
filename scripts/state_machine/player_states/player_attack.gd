extends State

# Assign other states
@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State

# Can combo flag
var can_combo_attack: bool

# AnimationTree reference
var playback: AnimationNodeStateMachinePlayback

# Start cooldowns and play Attack1 anim
func enter(prev_state: State) -> void:
	playback = parent.get_node("AnimationTree")["parameters/playback"]
	playback.travel("Attack1")
	
func physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and can_combo_attack:
		playback.travel("Attack2")
		
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

# Return true/false based on attacking animation
func is_attacking() -> bool:
	if playback.get_current_node() == "Attack1" or playback.get_current_node() == "Attack2":
		return true
	return false


func set_combo_allowed(can_combo: bool):
	can_combo_attack = can_combo
