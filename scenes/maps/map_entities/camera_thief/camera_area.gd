@tool extends AspectRatioContainer

var setter_enabled = true

@export_range(0.1, 10) var zoom = 1.0:
	set(v):
		zoom = v
		if setter_enabled:
			size.y = ProjectSettings.get("display/window/size/viewport_height") / zoom
			size.x = size.y * ratio

func _ready() -> void:
	resized.connect(func():
		setter_enabled = false
		zoom = ProjectSettings.get("display/window/size/viewport_height") / $ReferenceRect.size.y
		setter_enabled = true)
