extends "res://sound/sound_randomiser.gd"

@onready var sprite = get_parent() as AnimatedSprite2D

func _ready() -> void:
	sprite.frame_changed.connect(func():
		if sprite.animation == "run" and sprite.frame in [1,3]:
			play_random()
		)
