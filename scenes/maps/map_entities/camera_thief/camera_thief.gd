extends Polygon2D

@export var marker : CanvasItem
@export var visible_in_game = false
@export var oneshot = true
@export var travel_time = 1.0
@export var linger_time = 2.0

func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon
	if not visible_in_game:
		hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var camera = get_viewport().get_camera_2d()
	camera.set_process(false)
	var rect = marker.get_global_rect()
	var c_pos = rect.position + rect.size/2
	var zoom = Vector2.ONE * (get_window().size.y / rect.size.y)
	var t = create_tween()
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(camera, "position", c_pos, travel_time)
	t.parallel().tween_property(camera, "zoom", zoom, travel_time)
	if oneshot:
		t.tween_interval(linger_time)
		t.tween_property(camera, "position", Player.instance.global_position, travel_time)
		t.parallel().tween_property(camera, "zoom", Vector2(0.5,0.5), travel_time)
		t.tween_callback(camera.set_process.bind(true))
