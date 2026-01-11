class_name PlayerState extends State


var player: PlayerController
var animated_sprite: AnimatedSprite2D
var state_machine: StateMachine
var r_arm: Node2D
var l_arm: Node2D

func _init(player_controller: PlayerController) -> void:
	player = player_controller
	animated_sprite = player.animated_sprite
