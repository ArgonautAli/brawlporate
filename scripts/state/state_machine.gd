class_name StateMachine extends Node

var current_state: State
var states: Dictionary = {}
var parent_node_name: String

@export var is_logging: bool = false

func start_machine(init_states: Array[State]) -> void:
	for state in init_states:
		state.state_machine = self
		states[state.get_state_name()] = state
		
	current_state = init_states[0]
	parent_node_name = get_parent().name
	
	if is_logging:
		print("[%s] Entering state: \"%s\"" % [
			parent_node_name,
			current_state.get_state_name()
		])
		
	current_state.enter()


func _process(delta: float) -> void:
	current_state.process(delta)
	

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)

func transition(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name)

	if new_state == null:
		push_error("Non-existent state: %s" % new_state_name)
		return

	if new_state == current_state:
		return

	if is_logging:
		print("[%s] Exiting state: \"%s\"" % [
			parent_node_name,
			current_state.get_state_name()
		])

	current_state.exit()
	current_state = new_state

	if is_logging:
		print("[%s] Entering state: \"%s\"" % [
			parent_node_name,
			current_state.get_state_name()
		])

	current_state.enter()

	
