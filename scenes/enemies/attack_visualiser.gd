@tool
extends Line2D

func _process(delta: float) -> void:
	var v = owner.attack_vector
	if $"../../Sprite".flip_h:
		v.x *= -1
	points[1] = v/20.0 
