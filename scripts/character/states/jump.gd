extends PlayerState

var _can_land: bool = false


func enter() -> void:
	_can_land = false
	player.play_animation(&"jump")
	player.update_facing()
	player.apply_jump()


func physics_process(_delta: float) -> void:
	player.update_facing()
	player.apply_air_movement()


func physics_process_after_move() -> void:
	if not player.is_on_floor():
		_can_land = true
		return
	if _can_land or player.velocity.y >= 0.0:
		transition_to(player.ground_state_name())
