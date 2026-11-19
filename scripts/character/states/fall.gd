extends PlayerState


func enter() -> void:
	player.play_animation(&"jump")


func physics_process(_delta: float) -> void:
	player.update_facing()
	player.apply_air_movement()


func physics_process_after_move() -> void:
	if player.is_on_floor():
		transition_to(player.ground_state_name())
