class_name StateMachine
extends Node

@export var initial_state: NodePath = ^"Idle"
@export var is_logging: bool = false

var current_state: State

var _states: Dictionary = {}
var _started: bool = false
var _owner_name: String = ""


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	_owner_name = get_parent().name if get_parent() else name
	for child in get_children():
		if child is State:
			var state := child as State
			state.state_machine = self
			_states[StringName(state.name)] = state


func start() -> void:
	if _started:
		return
	current_state = _resolve_initial_state()
	if current_state == null:
		push_error("StateMachine '%s' has no initial_state." % name)
		return
	_started = true
	_log("Entering", current_state)
	current_state.enter()


func _resolve_initial_state() -> State:
	if not initial_state.is_empty():
		var node := get_node_or_null(initial_state)
		if node is State:
			return node as State
	if _states.has(&"Idle"):
		return _states[&"Idle"]
	if not _states.is_empty():
		return _states.values()[0]
	return null


func physics_tick(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)


func physics_tick_after_move() -> void:
	if current_state:
		current_state.physics_process_after_move()


func transition(state_name: StringName) -> void:
	var new_state: State = _states.get(state_name)
	if new_state == null:
		push_error("Non-existent state: %s" % state_name)
		return
	if new_state == current_state:
		return
	if current_state:
		_log("Exiting", current_state)
		current_state.exit()
	current_state = new_state
	_log("Entering", current_state)
	current_state.enter()


func _log(action: String, state: State) -> void:
	if is_logging and state:
		print("[%s] %s state: \"%s\"" % [_owner_name, action, state.name])
