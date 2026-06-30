extends CharacterBody2D

@onready var coyote_time: Timer = $CoyoteTime
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var _anim: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var combo_cooldown: Timer = $ComboCooldown

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var IS_ATTACKING = false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("attack"):
		if is_on_floor():
			attack()
		else:
			jump_attack()
	
	if IS_ATTACKING:
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_time.is_stopped()):
		velocity.y = JUMP_VELOCITY
	
	# Get direction based on actions
	var direction := Input.get_axis("move_left", "move_right")

	# Handle sprite flipping
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true

	# Handle movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Store last value of player being on floor
	var was_on_floor = is_on_floor()

	move_and_slide()
	
	# If player falls off, we start coyote timer
	if was_on_floor and !is_on_floor():
		coyote_time.start()
	

# Attack animation states
func attack() -> void:
	if _anim.get_current_node() == "Movement":
		_anim.travel("Attack1")
	elif _anim.get_current_node() == "Attack1" and !combo_cooldown.is_stopped():
		_anim.travel("Attack2")
	
	
func jump_attack() -> void:
	if _anim.get_current_node() == "Movement":
		_anim.travel("JumpAttack")
	

# Used in the animation to switch to attacking stance
func switch_attacking(new_val: bool) -> void:
	IS_ATTACKING = new_val
	
	
