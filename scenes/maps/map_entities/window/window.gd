class_name FragileWindow extends StaticBody2D

signal connected()
var has_connected = false
var connected_windows = [self]

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
	if abs(Player.instance.velocity.x) > 1000:
		for window in connected_windows:
			window.shatter()

func shatter():
	$CollisionShape2D.disabled = true
	queue_free()
