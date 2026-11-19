class_name PlayerState
extends State

var player: PlayerController


func _ready() -> void:
	player = owner as PlayerController
	if player == null:
		push_error("PlayerState '%s' owner is not a PlayerController." % name)


func transition_to(state_name: StringName) -> void:
	state_machine.transition(state_name)
