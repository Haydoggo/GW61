extends CharacterBody2D

@export_range(-PI/2, PI/2) var attack_angle = 0.0
@export_range(0,10000) var attack_power = 2000.0

func _ready() -> void:
	$Sprite.sprite_frames = [
		preload("res://scenes/enemies/frames_1.tres"),
		preload("res://scenes/enemies/frames_2.tres"),
		preload("res://scenes/enemies/frames_3.tres"),
		preload("res://scenes/enemies/frames_4.tres"),
		].pick_random()

func _process(_delta: float) -> void:
	if Player.instance:
		$Sprite.flip_h = Player.instance.global_position.x < global_position.x

func _on_damage_area_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		$HitEffect.global_position = player.global_position
		$AnimationPlayer.stop()
		$AnimationPlayer.play("attack")
		var attack_vector = Vector2.RIGHT.rotated(attack_angle)*attack_power
		if Player.instance.velocity.x > 0:
			attack_vector.x*=-1
		player.velocity += attack_vector
		player.is_grappling = false
		$Sprite.play("hit")
		await get_tree().create_timer(1).timeout
		$Sprite.play("standing")
		
