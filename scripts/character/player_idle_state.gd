class_name PlayerIdleState extends PlayerState

static var state_name = "PlayerIdleState"

func get_state_name() -> String:
	return state_name
	
func process(delta: float) -> void:
	player.handle_facing()

func physics_process(delta: float) -> void:
	if player.horizontal_input != 0.0:
		state_machine.transition(PlayerMovementState.state_name)
