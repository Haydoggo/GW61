@tool extends Node

@export var shortcut : InputEventKey

func _ready() -> void:
	if Engine.is_editor_hint():
		add_to_group("SelectorNodes")
	else:
		queue_free()
