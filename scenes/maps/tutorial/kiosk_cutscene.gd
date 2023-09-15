extends Control

var messages : Array[Message]
var current_message = 0
var message_progress = 0

signal finished()

@onready var text_box: Label = %TextBox
@onready var yes_button: Button = %Yes
@onready var no_button: Button = %No
@onready var continue_button: Button = %Continue

@onready var buttons : Array[Button] = [yes_button, no_button, continue_button]

var last_message : Message
var start_message

class Message extends RefCounted:
	var text : String
	var yes_message : Message
	var no_message : Message
	var continue_message : Message
	var done_signal : Signal

func _ready() -> void:
	yes_button.pressed.connect(func():show_message(last_message.yes_message))
	no_button.pressed.connect(func():show_message(last_message.no_message))
	continue_button.pressed.connect(func():show_message(last_message.continue_message))
	
	start_message = Message.new()
	var start_message_2 = Message.new()
	var start_message_3 = Message.new()
	var start_message_4 = Message.new()
	
	start_message.text = "Hello!"
	start_message.continue_message = start_message_2
	start_message_2.text = "Welcome!"
	start_message_2.continue_message = start_message_3
	start_message_3.text = "Howdy!"
	start_message_3.continue_message = start_message_4
	start_message_4.text = "Okay I'm done now, we can stop this foolish charade"
	start_message_4.done_signal = finished
	

func start():
	show_message(start_message)

func show_message(message : Message):
	last_message = message
	for button in buttons:
		button.hide()
	message_progress = 0
	var text = message.text
	
	while message_progress <= text.length():
		text_box.text = text.substr(0, message_progress)
		message_progress += 1
		await get_tree().physics_frame
	
	if message.continue_message:
		continue_button.show()
	if message.yes_message:
		yes_button.show()
	if message.no_message:
		no_button.show()
	if message.done_signal:
		message.done_signal.emit()
	
