class_name PlayerJumpState extends PlayerState

static var state_name = "PlayerJumpState"

const JUMP_FORCE: float = 350.0
const MAX_JUMP_FORCE: float = 2000.0

const ACCELERATION: float = 20.0
const MAX_SPEED: float = 150.0
const STOP_FORCE: float = 5.0

var is_jumping: bool = false

func get_state_name() -> String:
	return state_name
	

func enter() -> void:
	print("Enter jump")
	if player.is_on_floor():
		player.velocity.y = -JUMP_FORCE
	is_jumping = true

func exit() -> void:
	is_jumping = false

func process(_delta: float) -> void:
	animated_sprite.play("jump")

func physics_process(_delta: float) -> void:
	var input: float = player.horizontal_input * ACCELERATION
	
	if player.is_on_floor() and is_jumping:
		if input == 0.0:
			state_machine.transition(PlayerIdleState.state_name)
		else:
			state_machine.transition(PlayerMovementState.state_name)
		pass
	
	
	if abs(input) < ACCELERATION *0.2:
		player.velocity.x = move_toward(player.velocity.x, 0, STOP_FORCE)
	else:
		player.velocity.x += input
	
	player.velocity.x = clamp(player.velocity.x, -MAX_SPEED, MAX_SPEED)
