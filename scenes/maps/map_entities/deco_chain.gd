@tool extends Path2D

@onready var line: Line2D = $Line2D


func _ready() -> void:
	if Engine.is_editor_hint():
		curve.changed.connect(update_line)
	update_line()

func update_line():
	line.points = curve.get_baked_points()
