@tool extends Node
@onready var link_line: Line2D = %LinkLine


func _ready() -> void:
	await get_tree().process_frame
	if owner.owner and (owner.respawn_point == null):
		var marker = $"../Marker2D".duplicate()
		marker.show()
		marker.name = owner.name + "Respawn"
		marker.position = Vector2(32, 32)
		owner.add_child(marker)
		marker.owner = owner.owner
		owner.respawn_point = marker

func _process(delta: float) -> void:
	if owner.respawn_point:
		link_line.points[0] = link_line.to_local(owner.respawn_point.global_position)
