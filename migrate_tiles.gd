@tool
extends EditorScript

enum {
	Collision,
	SuperForeground,
	Foreground,
	Background,
	SuperBackground
}

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var src = get_scene().get_node("Tutorial/TileMap") as WorldMap
	var dst = get_scene().get_node("TileMap") as WorldMap
	for layer in src.get_layers_count():
		var cells = src.get_used_cells(layer)
		var cell_count = cells.size()
		var i = 0
		for cell in cells:
			var alt = src.get_cell_alternative_tile(layer, cell)
			var src_id = src.get_cell_source_id(layer, cell)
			var ac = src.get_cell_atlas_coords(layer, cell)
			var dst_cell = dst.local_to_map(dst.to_local(src.to_global(src.map_to_local(cell))))
			dst.set_cell(layer, dst_cell, src_id, ac, alt)
			
			if (i % 100) == 0:
				print("copied %d of %d" % [i, cell_count])
			i += 1
			
	src.clear()
			
			
			
			

