extends Camera2D

func _ready() -> void:
	process_priority = 1000

func _process(delta: float) -> void:
	global_position = get_parent().global_position.lerp(get_global_mouse_position(), 0.2)
	align()
