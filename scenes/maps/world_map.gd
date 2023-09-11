class_name WorldMap extends TileMap

enum TileProperty {
	NONE = 0,
	GRAPPLE = 1,
	BOOST = 2,
	JUMP = 4,
	DEATH = 8,
	FRAGILE = 16,
}

const TILE_PROPERTIES = {
	Vector2i(0,0) : TileProperty.GRAPPLE,
	Vector2i(1,0) : TileProperty.GRAPPLE | TileProperty.BOOST,
	Vector2i(2,0) : TileProperty.GRAPPLE | TileProperty.JUMP,
	Vector2i(3,0) : TileProperty.GRAPPLE | TileProperty.DEATH,
	Vector2i(0,1) : TileProperty.FRAGILE,
}

func global_to_atlas_coords(global_p : Vector2) -> Vector2i:
	var coords = local_to_map(to_local(global_p))
	return get_cell_atlas_coords(0, coords)

func get_alt_index(global_p : Vector2) -> int:
	var coords = local_to_map(to_local(global_p))
	return get_cell_alternative_tile(0, coords)

func get_properties(global_p : Vector2) -> int:
	var ac = global_to_atlas_coords(global_p)
	return TILE_PROPERTIES.get(ac, TileProperty.NONE)
