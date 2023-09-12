extends Polygon2D

@export var marker : Node2D
@export var visible_in_game = false

func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon
	if not visible_in_game:
		hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player and marker:
		player.respawn_point = marker.global_position
