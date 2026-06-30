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

	if IS_ATTACKING == true:
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
	

func attack() -> bool:
	if _anim.get_current_node() == "Movement":
		_anim.travel("Attack1")
		return true
	elif _anim.get_current_node() == "Attack1" and !combo_cooldown.is_stopped():
		_anim.travel("Attack2")
		return true
	return false
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and is_on_floor():
		attack()
		

func switch_attacking(new_val: bool) -> void:
	IS_ATTACKING = new_val
	
	
	
