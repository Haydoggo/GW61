@tool extends Node
@export var link_line: Line2D
@export var marker_template : CanvasItem

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()
		marker_template.queue_free()
	await get_tree().process_frame
	var new_owner = owner.owner
	if new_owner and (owner.marker == null):
		var marker = marker_template.duplicate()
		marker.name = owner.name + "Respawn"
		marker.position = Vector2(0, 32)
		owner.add_child(marker)
		
		#transfer ownership of marker and all children to new owner
		var children = [marker]
		var i = 0
		while i < children.size():
			var child = children[i]
			if child.owner == null:
				child.owner = new_owner
				children.append_array(child.get_children())
			i += 1
		owner.marker = marker
	marker_template.hide()

func _process(delta: float) -> void:
	if owner.marker:
		link_line.points[0] = link_line.to_local(owner.marker.global_position)
