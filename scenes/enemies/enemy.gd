extends CharacterBody2D

@export_range(-PI/2, PI/2) var attack_angle = 0.0
@export_range(0,10000) var attack_power = 2000.0

func _process(delta: float) -> void:
	if Player.instance:
		$Sprite.flip_h = Player.instance.global_position.x < global_position.x

func _on_damage_area_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		var attack_vector = Vector2.RIGHT.rotated(attack_angle)*attack_power
		if Player.instance.velocity.x > 0:
			attack_vector.x*=-1
		player.velocity += attack_vector
		player.is_grappling = false
		
