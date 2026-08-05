extends CharacterBody3D

var direction: Vector2

@export_group("Movement")
@export var speed: float

@onready var camera = $CameraController/Camera
@onready var skin = $Skin as Node3D

func _physics_process(delta: float) -> void:
	get_input()
	animate(delta)
	velocity.x = direction.x * speed 
	velocity.z = direction.y * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)

func animate(delta) -> void:
	if direction:
		skin.rotation.y = rotate_toward(skin.rotation.y, -direction.angle() + PI/2, 6.0 * delta)
