extends PlayerState


func enter() -> void:
	player.play_animation(&"idle")


func physics_process(_delta: float) -> void:
	player.update_facing()
	player.stop_horizontally()
	if player.wants_jump() and player.is_on_floor():
		transition_to(&"Jump")


func physics_process_after_move() -> void:
	if not player.is_on_floor():
		transition_to(&"Fall")
		return
	if player.is_moving():
		transition_to(&"Move")
