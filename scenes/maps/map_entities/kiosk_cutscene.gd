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
	var done_callback : Callable

func _ready() -> void:
	yes_button.pressed.connect(func():show_message(last_message.yes_message))
	no_button.pressed.connect(func():show_message(last_message.no_message))
	continue_button.pressed.connect(func():show_message(last_message.continue_message))
	
	start_message = Message.new()
	var start_message_no_1 = Message.new()
	var start_message_yes_1 = Message.new()
	var start_message_3 = Message.new()
	var start_message_4 = Message.new()
	var start_message_5 = Message.new()
	
	start_message.text = "Hello! Welcome to the fines appeal center self service kiosk! What department does your enquiry apply to?"
	start_message.yes_message = start_message_yes_1
	start_message.no_message = start_message_no_1
	start_message_yes_1.text = "Sorry, no department named [YES] was located on the database. Would you like to use our one click automated appeal resolution system?"
	start_message_no_1.text = "Sorry, no department named [NO] was located on the database. Would you like to use our one click automated appeal resolution system?"
	start_message_yes_1.yes_message = start_message_3
	start_message_no_1.yes_message = start_message_3
	start_message_3.text = "Appeal denied"
	start_message_3.done_callback = func():continue_button.text = "Thank you"
	start_message_3.continue_message = start_message_4
	start_message_4.text = "If you would like to appeal the results of your appeal, please bring forms A380, F2, C4, K9, BNC1, A380, A9, P72, P5, and A380 to upper management on the top floor"
	start_message_4.done_callback = func():continue_button.text = "Continue"
	start_message_4.continue_message = start_message_5
	start_message_5.text = "[MAINTAINENCE NOTICE]\n\nThe elevator is currently out of order"
	start_message_5.done_callback= func():finished.emit();for button in buttons: button.hide()
	

func start():
	show_message(start_message)

func show_message(message : Message):
	last_message = message
	for button in buttons:
		button.disabled = true
	message_progress = 0
	var text = message.text
	
	while message_progress <= text.length():
		text_box.text = text.substr(0, message_progress)
		message_progress += 1
		await get_tree().physics_frame
	
	if message.no_message:
		no_button.disabled = false
		no_button.grab_focus()
	if message.yes_message:
		yes_button.disabled = false
		yes_button.grab_focus()
	if message.continue_message:
		continue_button.disabled = false
		continue_button.grab_focus()
	if message.done_callback:
		message.done_callback.call()
	
