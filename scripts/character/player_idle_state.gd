class_name PlayerIdleState extends PlayerState

static var state_name = "PlayerIdleState"

func get_state_name() -> String:
	return state_name
	
func process(delta: float) -> void:
	animated_sprite.play("idle")
	if Input.is_action_just_pressed("jump"):
		state_machine.transition("PlayerJumpState")
		pass
	player.handle_facing()

func physics_process(delta: float) -> void:
	if player.horizontal_input != 0.0:
		state_machine.transition(PlayerMovementState.state_name)
