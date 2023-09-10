class_name WorldMap extends TileMap

enum TileProperty {
	NONE = 0,
	NORMAL = 1,
	BOOST = 2,
	JUMP = 4,
}

const TILE_PROPERTIES = {
	Vector2i(0,0) : TileProperty.NORMAL,
	Vector2i(1,0) : TileProperty.NORMAL | TileProperty.BOOST,
	Vector2i(2,0) : TileProperty.NORMAL | TileProperty.JUMP,
}

func global_to_atlas_coords(global_p : Vector2):
	var coords = local_to_map(to_local(global_p))
	return get_cell_atlas_coords(0, coords)

func get_alt_index(global_p : Vector2):
	var coords = local_to_map(to_local(global_p))
	return get_cell_alternative_tile(0, coords)

func get_properties(global_p : Vector2):
	var ac = global_to_atlas_coords(global_p)
	return TILE_PROPERTIES.get(ac, TileProperty.NONE)
