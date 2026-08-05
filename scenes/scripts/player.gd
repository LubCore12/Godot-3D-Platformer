class_name Player
extends CharacterBody3D

var direction: Vector2

@export_group("Movement")
@export var speed: float
@export var move_acceleration: float
@export var friction: float

@export_group("Jumping")
@export var jump_strength: float
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var camera = $CameraController/Camera
@onready var skin = $Skin as Node3D

func _physics_process(delta: float) -> void:
	get_input()
	move(delta)
	apply_gravity(delta)
	move_and_slide()
	animate(delta)
	
func move(delta) -> void:
	var velocity_2d = Vector2(velocity.x, velocity.z)
	if direction:
		velocity_2d += direction * speed * delta * move_acceleration
		velocity_2d = velocity_2d.limit_length(speed)
		velocity.x = velocity_2d.x
		velocity.z = velocity_2d.y
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO, speed * friction * delta)
		velocity.x = velocity_2d.x
		velocity.z = velocity_2d.y
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

func animate(delta) -> void:
	if direction:
		skin.rotation.y = rotate_toward(skin.rotation.y, -direction.angle() + PI/2, 6.0 * delta)

func jump() -> void:
	velocity.y = jump_strength
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		var gravity = jump_gravity if velocity.y > 0 else fall_gravity
		velocity.y -= gravity * delta
