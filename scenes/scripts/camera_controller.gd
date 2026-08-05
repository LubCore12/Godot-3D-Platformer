extends Node3D

@export_group("Camera Movement")
@export var mouse_acceleration: float
@export var horizontal_acceleration: float
@export var vertical_acceleration: float
@export var x_min_limit: float
@export var x_max_limit: float

func _process(delta: float) -> void:
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	rotate_from_vector(joy_dir * Vector2(horizontal_acceleration, vertical_acceleration) * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acceleration)
		
func rotate_from_vector(vector: Vector2) -> void:
	if vector.length():
		rotation.y += vector.x
		$Camera.rotation.x += vector.y
		$Camera.rotation.x = clamp($Camera.rotation.x, x_min_limit, x_max_limit)
	
