extends Control

@export_range(0, 1) var intensity = 1.0:
	set(v):
		intensity = v
		modulate.a = intensity
@export var spike_count = 64
@onready var woosh_sfx: AudioStreamPlayer = $"../../WooshSFX"

@onready var spike_templates = get_children()

var spikes = []

func _ready() -> void:
	for child in get_children():
		child.hide()
	for i in spike_count:
		var spike = spike_templates.pick_random().duplicate() as Node2D
		add_child(spike)
		spike.show()
		spikes.append(spike)

func _process(delta: float) -> void:
	intensity = clamp(inverse_lerp(1000, 5000, Player.instance.velocity.length()), 0, 1)
	woosh_sfx.volume_db = linear_to_db(move_toward(db_to_linear(woosh_sfx.volume_db), min(intensity*2.0, 1), delta * 6))
	if intensity == 0: return
	var ratio = size.x/size.y
	for spike in spikes:
		if randf()*(ratio + 1) > ratio:
			spike.position.x = [0, size.x].pick_random()
			spike.position.y = randf()*size.y
		else:
			spike.position.y = [0, size.y].pick_random()
			spike.position.x = randf()*size.x
		spike.look_at(position + size/2)
		spike.position = spike.position.move_toward(size/2, -randf()*128 - (1-intensity)*64)
