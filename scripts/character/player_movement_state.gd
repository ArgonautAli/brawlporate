class_name PlayerMovementState extends PlayerState

static var state_name = "PlayerMovementState"

const ACCELERATION: float = 20.0
const MAX_SPEED: float = 150.0

func get_state_name() -> String:
	return state_name

func process(delta: float) -> void:
	player.handle_facing()

func physics_process(delta: float) -> void:
	var target_speed := player.horizontal_input * MAX_SPEED
	player.velocity.x = move_toward(
		player.velocity.x,
		target_speed,
		ACCELERATION
	)
