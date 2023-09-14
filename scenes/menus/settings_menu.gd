extends Control

signal return_to_previous()

@export var sliders : Array[HSlider]

@onready var cf = ConfigFile.new()

func _ready() -> void:
	var i = 0
	for slider in sliders:
		var label = slider.get_child(0) as Label
		slider.value_changed.connect(func(val:float):
			cf.set_value("Volume", AudioServer.get_bus_name(i), val)
			label.text = "%d%%"%val
			AudioServer.set_bus_volume_db(i, linear_to_db(val/100.0))
		)
		i+=1
	load_settings()
	

func load_settings():
	if cf.load("user://settings.txt") == ERR_CANT_OPEN:
		return
	for i in AudioServer.bus_count:
		var vol = cf.get_value("Volume", AudioServer.get_bus_name(i), 100.0)
		AudioServer.set_bus_volume_db(i, linear_to_db(vol/100.0))
	
	var i = 0
	for slider in sliders:
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(i))*100.0
		i += 1

func save_settings():
	cf.save("user://settings.txt")

func _on_return_pressed() -> void:
	save_settings()
	return_to_previous.emit()
