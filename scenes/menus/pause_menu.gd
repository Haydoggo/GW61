extends CanvasLayer
@onready var pause_menu_content: CenterContainer = $MarginContainer/PauseMenuContent
@onready var settings_menu_content: Control = $MarginContainer/SettingsMenuContent

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") \
			and get_tree().current_scene.name != "MainMenu" \
			and not get_tree().paused:
		pause()
		get_viewport().set_input_as_handled()

func pause():
	show()
	get_tree().paused = true

func unpause():
	hide()
	get_tree().paused = false
	pause_menu_content.show()
	settings_menu_content.hide()

func _on_settings_pressed() -> void:
	pause_menu_content.hide()
	settings_menu_content.show()


func _on_settings_menu_return_to_previous() -> void:
	pause_menu_content.show()
	settings_menu_content.hide()


func _on_menu_pressed() -> void:
	get_tree().current_scene.get_node("CanvasLayer/VBoxContainer").change_to_map.call_deferred(preload("res://scenes/menus/main_menu.tscn"))
	unpause()


func _on_respawn_pressed() -> void:
	if Player.instance:
		Player.instance.die()
		unpause()
