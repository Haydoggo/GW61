extends AudioStreamPlayer
@export var sounds : Array[AudioStream]

func play_random():
	var random_stream = sounds.pick_random() as AudioStream
	var asp = duplicate(0)
	asp.stream = random_stream
	add_child(asp)
	asp.play()
	asp.finished.connect(asp.queue_free)
	print(random_stream.resource_path)
