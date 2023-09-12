extends Control

@onready var menu_content: CenterContainer = $MenuContent
@onready var settings: Control = $Settings


func _on_settings_pressed() -> void:
	settings.show()
	menu_content.hide()


func _on_settings_return_to_previous() -> void:
	menu_content.show()
	settings.hide()


func _on_quit_pressed() -> void:
	get_tree().quit()
