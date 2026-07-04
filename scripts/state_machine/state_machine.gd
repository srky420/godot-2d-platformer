class_name StateMachine extends Node

# Set the initial state from editor
@export var initial_state: State

# Store current state
var current_state: State

# Setup the initial state
func _ready() -> void:
	# Set the parent node and state machine for
	# All the child states
	var parent_node = get_parent()
	for child in get_children():
		if child is State:
			child.parent = parent_node
			child.state_machine = self

	# Initialize current state to inital state	
	if initial_state:
		current_state = initial_state
		current_state.enter(null)
	
# Delegate the engine's _physics_process and process
# To the current state's physics_process and process
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

# Transition to new state function
# Can be used by states to transition b/w each other
func transition_to(target_state: State) -> void:
	if target_state == current_state:
		return
	
	# Debug message
	print("[StateMachine] ", current_state.name, " -> ", target_state.name)
	
	# Call necessary exit and enter funcs 
	# On old and new states
	var prev_state = current_state
	current_state.exit()
	current_state = target_state
	current_state.enter(prev_state)
