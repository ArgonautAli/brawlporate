class_name PlayerController
extends CharacterBody2D

enum Facing { LEFT, RIGHT }

@export var stats: PlayerStats

var move_axis: float = 0.0
var facing: Facing = Facing.RIGHT

@onready var visuals: Node2D = $Visuals
@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	if stats == null:
		stats = PlayerStats.new()
	state_machine.start()


func _physics_process(delta: float) -> void:
	move_axis = Input.get_axis("move_left", "move_right")
	state_machine.physics_tick(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	state_machine.physics_tick_after_move()


func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")


func is_moving() -> bool:
	return not is_zero_approx(move_axis)


func ground_state_name() -> StringName:
	return &"Move" if is_moving() else &"Idle"


func play_animation(anim: StringName) -> void:
	if animated_sprite.animation != anim or not animated_sprite.is_playing():
		animated_sprite.play(anim)


func update_facing() -> void:
	if move_axis < 0.0:
		_set_facing(Facing.LEFT)
	elif move_axis > 0.0:
		_set_facing(Facing.RIGHT)


func apply_ground_movement() -> void:
	velocity.x = move_toward(velocity.x, move_axis * stats.max_speed, stats.move_acceleration)


func apply_air_movement() -> void:
	var air_input := move_axis * stats.air_acceleration
	if absf(air_input) < stats.air_acceleration * 0.2:
		velocity.x = move_toward(velocity.x, 0.0, stats.air_stop_force)
	else:
		velocity.x += air_input
	velocity.x = clampf(velocity.x, -stats.max_speed, stats.max_speed)


func stop_horizontally() -> void:
	velocity.x = move_toward(velocity.x, 0.0, stats.move_acceleration)


func apply_jump() -> void:
	velocity.y = -stats.jump_force


func _set_facing(new_facing: Facing) -> void:
	if facing == new_facing:
		return
	facing = new_facing
	visuals.scale.x = -1.0 if facing == Facing.LEFT else 1.0
