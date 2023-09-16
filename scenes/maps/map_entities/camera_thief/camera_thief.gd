extends Polygon2D

signal activated()

@export var enabled = true
@export var oneshot = false
@export var marker : CanvasItem
@export var visible_in_game = false
@export var zoom_in_time = 1.0
@export var zoom_out_time = 1.0
@export var zoom_only = false
@export var temporary = false

@onready var camera = get_viewport().get_camera_2d()

func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon
	if not visible_in_game:
		hide()


func zoom_in():
	activated.emit()
	var rect = marker.get_global_rect()
	var zoom = Vector2.ONE * (ProjectSettings.get("display/window/size/viewport_height") / rect.size.y)
	var t = create_tween()
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	var targ_pos = rect.position + rect.size/2
	if not zoom_only:
		if camera.target_controller != Player.instance and not camera.target_controller.zoom_only:
			t.tween_property(camera, "external_target_position", targ_pos, zoom_in_time)
		else:
			camera.external_target_position = targ_pos
			t.tween_property(camera, "target_selection", 0.0, zoom_in_time)
	t.parallel().tween_property(camera, "zoom", zoom, zoom_in_time)
	if not temporary:
		camera.default_zoom = zoom

func zoom_out():
	var t = create_tween()
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(camera, "target_selection", 1.0, zoom_out_time)
	t.parallel().tween_property(camera, "zoom", camera.default_zoom, zoom_out_time)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if enabled:
		await get_tree().process_frame
		if oneshot:
			enabled = false
		zoom_in()
		camera.target_controller = self

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if temporary and camera.target_controller == self:
		zoom_out()
		camera.target_controller = Player.instance
