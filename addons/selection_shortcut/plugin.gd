@tool
extends EditorPlugin

func _shortcut_input(event: InputEvent) -> void:
	var nodes = []
	for selector in get_tree().get_nodes_in_group("SelectorNodes"):
		if event.is_match(selector.shortcut):
			nodes.append(selector.get_parent())
	if not nodes.is_empty():
		var ei = get_editor_interface()
		ei.get_selection().clear()
		for node in nodes:
			ei.get_selection().add_node(node)
			ei.edit_node(node)
		get_viewport().set_input_as_handled()
