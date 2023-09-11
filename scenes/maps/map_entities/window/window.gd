class_name FragileWindow extends StaticBody2D

var connected_windows = [self]

func _ready() -> void:
	$Up.force_raycast_update()
	if $Up.get_collider() is FragileWindow:
		connected_windows = $Up.get_collider().connected_windows
		connected_windows.append(self)
	$Up.queue_free()

func collide():
	if abs(Player.instance.velocity.x) > 1000:
		for window in connected_windows:
			window.shatter()

func shatter():
	$CollisionShape2D.disabled = true
	queue_free()
