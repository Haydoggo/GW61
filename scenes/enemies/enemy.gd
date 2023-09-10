extends CharacterBody2D

@export var attack_vector = Vector2.UP*600

func _on_damage_area_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		player.velocity += attack_vector
		player.is_grappling = false
		
