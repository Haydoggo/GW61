extends VBoxContainer

@export var maps : Array[PackedScene]
var current_map
var last_map : PackedScene

func _ready() -> void:
	var restart_button = Button.new()
	restart_button.text = "Restart"
	restart_button.focus_mode = Control.FOCUS_NONE
	add_child(restart_button)
	restart_button.pressed.connect(func():change_to_map(last_map))
	for map in maps:
		var button = Button.new()
		button.pressed.connect(change_to_map.bind(map))
		button.text = map.resource_path.get_file().get_basename()
		button.focus_mode = Control.FOCUS_NONE
		add_child(button)
	change_to_map.call_deferred(maps[0])

func change_to_map(map:PackedScene):
	last_map = map
	if current_map:
		current_map.free()
	current_map = map.instantiate()
	owner.add_child(current_map)
	
