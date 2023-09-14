extends AudioStreamPlayer
@export var sounds : Array[AudioStream]

func play_random():
	var stream = sounds.pick_random()
	var asp = duplicate(0)
	asp.stream = stream
	asp.finished.connect(asp.queue_free)
	add_child(asp)
	asp.play()
