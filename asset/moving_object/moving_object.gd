class_name MovingObject extends Path3D

@export var time: float = 2.0

var path_follower: PathFollow3D = get_child(0) as PathFollow3D
var timer: Timer

func _ready() -> void:
	assert(path_follower != null)
	timer = Timer.new()
	timer.start(time)

func _process(delta: float) -> void:
	path_follower.progress_ratio = timer.wait_time - timer.time_left / timer.wait_time
