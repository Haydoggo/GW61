class_name FragileWindow extends StaticBody2D

signal connected()
var has_connected = false
var connected_windows = [self]
var has_shattered = false

@onready var shatter_effect: CPUParticles2D = $CPUParticles2D

signal sync

func _ready() -> void:
	# wait for all the windows to be in the train
	(func():sync.emit()).call_deferred()
	await sync
	$Up.force_raycast_update()
	var window = $Up.get_collider() as FragileWindow
	if window:
		if not window.has_connected:
			await window.connected
		connected_windows = $Up.get_collider().connected_windows
		connected_windows.append(self)
	$Up.queue_free()
	has_connected = true
	connected.emit()

func collide():
	if has_shattered:
		return
	if abs(Player.instance.velocity.dot(global_transform.x)) > 800:
		for window in connected_windows:
			window.shatter()
		var sfx = $ShatterSFX as AudioStreamPlayer
		sfx.pitch_scale = randf_range(0.9, 1.1)
		sfx.reparent(get_tree().root)
		sfx.play()
		sfx.finished.connect(sfx.queue_free)
	
	

func shatter():
	$CollisionShape2D.disabled = true
	shatter_effect.reparent(get_parent())
	shatter_effect.emitting = true
	if Player.instance.velocity.x < 0:
		shatter_effect.direction.x *= -1
	get_tree().create_timer(shatter_effect.lifetime).timeout.connect(shatter_effect.queue_free)
	queue_free()
	has_shattered = true
