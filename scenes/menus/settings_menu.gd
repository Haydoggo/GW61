extends Control

signal return_to_previous()

@export var sliders : Array[HSlider]

func _ready() -> void:
	var i = 0
	for slider in sliders:
		var label = slider.get_child(0) as Label
		slider.value_changed.connect(func(val:float):
			label.text = "%d%%"%val
			AudioServer.set_bus_volume_db(i, linear_to_db(val/100.0))
		)
		i+=1


func _on_return_pressed() -> void:
	return_to_previous.emit()
