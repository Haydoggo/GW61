extends Control

@onready var camera = get_viewport().get_camera_2d()

func _process(_delta: float) -> void:
	hide()
	var closest_doc : Node2D = null
#	var dist_to_closest = INF
#	for doc in get_tree().get_nodes_in_group(&"Documents"):
#		doc = doc as Node2D
#		var doc_pos = doc.global_position
#		var dist_to_doc = camera.global_position.distance_to(doc_pos)
#		if dist_to_doc < dist_to_closest:
#			closest_doc = doc
#			dist_to_closest = dist_to_doc
	if get_tree().get_nodes_in_group(&"Documents").size() > 0:
		closest_doc = get_tree().get_nodes_in_group(&"Documents")[0]
	
	if closest_doc:
		var osn = closest_doc.get_node("VisibleOnScreenNotifier2D") as VisibleOnScreenNotifier2D
		if not osn.is_on_screen():
			show()
			rotation = camera.global_position.angle_to_point(closest_doc.global_position)
			$Visual.global_rotation = 0
