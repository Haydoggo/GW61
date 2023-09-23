extends Button

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()

func _pressed() -> void:
	Player.instance.global_position = get_child(0).global_position
