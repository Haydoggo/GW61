extends CharacterBody2D

@export var attack_vector = Vector2.UP*600

func _process(delta: float) -> void:
	$Sprite.flip_h = Player.instance.global_position.x < global_position.x

func _on_damage_area_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		var v = attack_vector
		if $Sprite.flip_h:
			v.x*=-1
		player.velocity += v
		player.is_grappling = false
		
