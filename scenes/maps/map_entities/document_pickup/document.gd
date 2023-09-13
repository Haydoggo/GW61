extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	var sfx = $PickupSFX as AudioStreamPlayer
	sfx.reparent(get_tree().root)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
	queue_free()
