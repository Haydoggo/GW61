class_name WorldMap extends TileMap

const boost_tile = Vector2i(1,0)

func global_to_atlas_coords(global_postion : Vector2):
	var coords = local_to_map(to_local(global_postion))
	return get_cell_atlas_coords(0, coords)
