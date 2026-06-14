extends Area2D

@onready var game_manager: Node = %GameManager


func _on_body_entered(body: Node2D) -> void:
	print("Coin +1")
	game_manager.update_score()
	queue_free()
