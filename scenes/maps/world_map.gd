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
	Vector3i(0,0,0) : TileProperty.GRAPPLE,
	Vector3i(1,0,0) : TileProperty.GRAPPLE | TileProperty.BOOST,
	Vector3i(2,0,0) : TileProperty.GRAPPLE | TileProperty.JUMP,
	Vector3i(3,0,0) : TileProperty.GRAPPLE | TileProperty.DEATH,
	
	# Sheet 2
	# Spikes
	Vector3i(9,2,2) : TileProperty.GRAPPLE | TileProperty.DEATH,
	Vector3i(9,3,2) : TileProperty.GRAPPLE | TileProperty.DEATH,
}

func global_to_atlas_coords(global_p : Vector2) -> Vector2i:
	var coords = local_to_map(to_local(global_p))
	return get_cell_atlas_coords(0, coords)

func get_alt_index(global_p : Vector2) -> int:
	var coords = local_to_map(to_local(global_p))
	return get_cell_alternative_tile(0, coords)

func get_properties(global_p : Vector2) -> int:
	var coords = local_to_map(to_local(global_p))
	var ac = global_to_atlas_coords(global_p)
	var source = get_cell_source_id(0, coords)
	return TILE_PROPERTIES.get(Vector3i(ac.x, ac.y, source), TileProperty.GRAPPLE)
