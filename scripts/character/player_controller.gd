class_name PlayerController extends CharacterBody2D

enum Facing{LEFT, RIGHT}

var horizontal_input: float = 0.0

var _facing: Facing = Facing.RIGHT

@onready var animated_sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var r_arm: Marker2D = $r_arm
@onready var l_arm: Marker2D = $l_arm
@onready var r_arm_sprite_2d: Sprite2D = $r_arm/Sprite2D
@onready var l_arm_sprite_2d: Sprite2D = $l_arm/Sprite2D

func _ready() -> void:
	var states: Array[State] = [PlayerIdleState.new(self), PlayerMovementState.new(self)]
	state_machine.start_machine(states)


func _physics_process(delta: float) -> void:
	horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_and_slide()
	

func handle_facing() -> void:
	var flip: int = 0

	if horizontal_input < 0.0:
		flip = 1
	elif horizontal_input > 0.0:
		flip = -1
	
	if flip == -1:
		animated_sprite.flip_h = false
		r_arm_sprite_2d.flip_h = false
		l_arm_sprite_2d.flip_h = false
		r_arm.position.x = -2
		_facing = Facing.RIGHT
	elif flip == 1:
		animated_sprite.flip_h = true
		r_arm_sprite_2d.flip_h = true
		l_arm_sprite_2d.flip_h = true
		r_arm.position.x = 2
		_facing = Facing.LEFT
