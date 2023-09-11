extends VBoxContainer

@export var maps : Array[PackedScene]
@export var current_map : Node

func _ready() -> void:
	for map in maps:
		var button = Button.new()
		button.pressed.connect(change_to_map.bind(map))
		button.text = map.resource_path.get_file().get_basename()
		button.focus_mode = Control.FOCUS_NONE
		add_child(button)
	change_to_map.call_deferred(maps[0])

func change_to_map(map:PackedScene):
	if current_map:
		current_map.free()
	current_map = map.instantiate()
	owner.add_child(current_map)
	
