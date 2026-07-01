class_name State extends Node

# Parent reference (CharacterBody2D)
var parent: CharacterBody2D

# StateMachine reference
var state_machine: StateMachine

# State enter, exit, physics_process and process
func enter(prev_state: State) -> void:
	pass

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass

func process(delta: float) -> void:
	pass
