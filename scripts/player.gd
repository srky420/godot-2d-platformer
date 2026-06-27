extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time: Timer = $CoyoteTime
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var LEFT_FLOOR = false

func _physics_process(delta: float) -> void:
	
	if LEFT_FLOOR and is_on_floor():
		animation_player.play("jump_squeeze")
		LEFT_FLOOR = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		LEFT_FLOOR = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_time.is_stopped()):
		velocity.y = JUMP_VELOCITY
		LEFT_FLOOR = true
		animation_player.play("jump_squeeze")
	
	# Get direction based on actions
	var direction := Input.get_axis("move_left", "move_right")

	# Handle sprite flipping
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Hanlde animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y > 0:
			animated_sprite_2d.play("fall")
		else:
			animated_sprite_2d.play("jump")

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

	
	
