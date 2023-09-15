extends Area2D

@onready var player = Player.instance
var highlighted = false :
	set(v):
		highlighted = v
		$Highlight.visible = highlighted and player.can_grapple

var attached = false:
	set(v):
		attached = v
		set_physics_process(attached)

func _ready() -> void:
	set_physics_process(false)
	player.grapple_released.connect(func():attached = false)
	player.retraction_finised.connect(func():
		if attached:
			player.is_grappling = false)

func _physics_process(_delta: float) -> void:
	if player.grapple_length < 128:
		player.is_grappling = false
	
	
func grapple():
	player.retract_grapple()
	(func():
		player.hook_position = global_position
		player.grapple_length = global_position.distance_to(player.grapple_ray.global_position)
	).call_deferred()
	attached = true
	return true
