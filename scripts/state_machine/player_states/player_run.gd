extends State

# Player speed
@export var speed: float
@export var player_sprite: Sprite2D

# Other state references
@export var idle_state: State
@export var fall_state: State
@export var jump_state: State

func physics_process(delta: float) -> void:
	# Apply gravity and movement
	var gravity = parent.get_gravity()
	if not parent.is_on_floor():
		parent.velocity += gravity * delta
	
	# Movemeent based on direction
	var direction := Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * speed
	parent.move_and_slide()
	if player_sprite and direction != 0.0:
		player_sprite.flip_h = direction < 0.0
		
	# Transition to other states
	
	
	
	
