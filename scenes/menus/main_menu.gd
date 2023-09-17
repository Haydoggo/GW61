extends Control

@onready var menu_content: CenterContainer = $MenuContent
@onready var settings: Control = $Settings

func _ready() -> void:
	if OS.get_name() == "Web":
		$MenuContent/VBoxContainer/Quit.hide()

func _on_settings_pressed() -> void:
	settings.show()
	menu_content.hide()


func _on_settings_return_to_previous() -> void:
	menu_content.show()
	settings.hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().current_scene.get_node("CanvasLayer/VBoxContainer").change_to_map.call_deferred(preload("res://scenes/maps/game_map.tscn"))
