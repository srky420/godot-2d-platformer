extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50
var DIR = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check and update direction
	if ray_cast_right.is_colliding():
		DIR = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		DIR = 1
		animated_sprite_2d.flip_h = false
	
	# Move the enemy
	position.x += DIR * SPEED * delta
