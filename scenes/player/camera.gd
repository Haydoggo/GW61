extends Camera2D

const default_zoom = Vector2(0.5, 0.5)
#to be controlled externally by things like cutscenes
var external_target_position : Vector2
var target_position : Vector2
var target_selection = 1.0 # range from 0 to 1 to lerp ext_targ to targ
@onready var target_controller = Player.instance

func _ready() -> void:
	process_priority = 1000

func _process(delta: float) -> void:
	target_position = get_parent().global_position.lerp(get_global_mouse_position(), 0.2)
	global_position = external_target_position.lerp(target_position, target_selection)
	align()
