extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		unpause() if get_tree().paused else pause()

func pause():
	show()
	get_tree().paused = true

func unpause():
	hide()
	get_tree().paused = false
