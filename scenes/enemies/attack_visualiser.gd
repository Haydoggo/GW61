@tool
extends Line2D

func _process(delta: float) -> void:
	points[1] = owner.attack_vector/20.0
