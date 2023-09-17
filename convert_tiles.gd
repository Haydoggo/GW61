@tool
extends EditorScript

enum {
	Collision,
	SuperForeground,
	Foreground,
	Background,
	SuperBackground
}


func _run() -> void:
	var tm = get_scene().get_node("TileMap") as TileMap
	var dtm = get_scene().get_node("DecorativeTileMap") as TileMap
	
	if dtm:
		# migrate decorative tiles onto main tilemap
		for dtm_layer in [0,1]:
			for cell in dtm.get_used_cells(dtm_layer):
				var ac = dtm.get_cell_atlas_coords(dtm_layer, cell)
				var layer = SuperBackground
				if dtm_layer == 0:
					if tm.get_cell_source_id(Collision, cell) > -1:
						layer = Collision
					else:
						layer = Foreground
				tm.set_cell(Collision if (dtm_layer==0) else SuperBackground, cell, 2, ac)
				dtm.erase_cell(dtm_layer, cell)
	
	for cell in tm.get_used_cells(Foreground):
		var screens = [Vector2i(2,2), Vector2i(2,3), Vector2i(3,2), Vector2i(3,3)]
		var ac = tm.get_cell_atlas_coords(Foreground, cell)
		if tm.get_cell_source_id(Foreground, cell) == 2 and ac in screens:
			tm.set_cell(Foreground, cell)
			tm.set_cell(Background, cell, 2, ac)
			print(cell)
	
	# convert grey blocks to terrain
	tm.set_cells_terrain_connect(Collision, tm.get_used_cells_by_id(Collision, 0, Vector2i(0,0)), 0, 0)

	# convert background blocks to terrain
	tm.set_cells_terrain_connect(SuperBackground, tm.get_used_cells_by_id(SuperBackground, 2, Vector2i(4,0)), 0, 0)
