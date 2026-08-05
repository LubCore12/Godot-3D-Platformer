extends CharacterBody3D

var direction: Vector2

@export_group("Movement")
@export var speed: float

@onready var camera = $CameraController/Camera

func _physics_process(_delta: float) -> void:
	get_input()
	velocity.x = direction.x * speed 
	velocity.z = direction.y * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
