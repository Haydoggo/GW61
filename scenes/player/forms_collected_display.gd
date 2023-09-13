extends Label

@onready var num_forms = get_tree().get_nodes_in_group(&"Documents").size()

func _process(_delta: float) -> void:
	var collected_forms = num_forms - get_tree().get_nodes_in_group(&"Documents").size()
	text = "%d/%d" % [collected_forms, num_forms]
