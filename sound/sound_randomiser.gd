extends AudioStreamPlayer
@export var sounds : Array[AudioStream]

func play_random():
	var stream = sounds.pick_random()
	var asp = duplicate(0)
	asp.stream = stream
	add_child(asp)
	asp.play()
	asp.finished.connect(asp.queue_free)
