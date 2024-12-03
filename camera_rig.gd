class_name CameraRig extends SpringArm3D

@export var pivot: Node3D = null
@export var offset: Vector3 = Vector3.ZERO
@export var smoothiness: float = 15

func _ready() -> void:
	if pivot != null:
		global_position = pivot.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var final_position = Vector3.ZERO
	
	if pivot != null:
		global_position.x = lerp(global_position.x, pivot.global_position.x + offset.x, delta * smoothiness)
		global_position.z = lerp(global_position.z, pivot.global_position.z + offset.z, delta * smoothiness)
	if pivot is CharacterBody3D:
		var player: CharacterBody3D = pivot as CharacterBody3D
		if player.is_on_floor():
			global_position.y = lerp(global_position.y, pivot.global_position.y + offset.y, delta * smoothiness)
