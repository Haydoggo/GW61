extends Polygon2D

@export var respawn_point : Node2D

func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon
	hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player and respawn_point:
		player.respawn_point = respawn_point.global_position
