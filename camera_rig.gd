class_name CameraRig extends SpringArm3D

@export var pivot: Node3D = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pivot != null:
		global_position = pivot.global_position
