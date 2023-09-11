@tool
extends Line2D

func _process(delta: float) -> void:
	var attack_vector = Vector2.RIGHT.rotated(owner.attack_angle)*owner.attack_power
	if $"../../Sprite".flip_h:
		attack_vector.x *= -1
	points[1] = attack_vector/20.0 
