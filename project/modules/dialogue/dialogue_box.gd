extends Control

signal dialogue_started
signal dialogue_finished

@export var TemplateOption: PackedScene

@onready var CurrentSpeakerName: RichTextLabel = $SpeakerName
@onready var CurrentLineText: RichTextLabel = $LineText
@onready var CurrentSpeakerImage: TextureRect = $SpeakerImage
@onready var LineOptions: VBoxContainer = $LineOptions
@onready var NextLineButton: Button = $NextLineButton

var current_container: DialogueContainer
var current_line: DialogueLine
var is_typing: bool = false

func _ready() -> void:
	NextLineButton.button_down.connect(on_next_pressed)

func start_dialogue(container: DialogueContainer) -> void:
	current_container = container
	show_line(container.get_line_by_id(container.start_id))
	self.visible = true
	dialogue_started.emit()

func show_line(line: DialogueLine) -> void:
	CurrentLineText.text = ""
	
	if line == null:
		close_dialogue()
		return
	
	clear_options()
	current_line = line
	CurrentSpeakerName.text = line.speaker_name
	CurrentSpeakerImage.texture = line.speaker_image
	
	if line.options.is_empty() and line.next_line_id == "":
		NextLineButton.text = "Close (Press E)"
	else:
		NextLineButton.text = "Next (Press E)"
	NextLineButton.visible = true

	is_typing = true
	for character in line.text:
		if is_typing == false:
			break
		CurrentLineText.text += character
		await get_tree().create_timer(0.025).timeout
	is_typing = false

func on_next_pressed() -> void:
	if is_typing:
		CurrentLineText.text = current_line.text
		is_typing = false
	else:
		if not current_line.options.is_empty():
			show_options()
		elif current_line.next_line_id != "":
			show_line(current_container.get_line_by_id(current_line.next_line_id))
		else:
			close_dialogue()

func show_options() -> void:
	if LineOptions.visible:
		return
	else:
		LineOptions.visible = true
		NextLineButton.visible = false
		
		for option in current_line.options:
			var btn = TemplateOption.instantiate()
			btn.text = option.text
			btn.pressed.connect(on_option_pressed.bind(option))
			LineOptions.add_child(btn)

func on_option_pressed(option: DialogueOption) -> void:
	if option.effect != "":
		 # TODO: There should be an utils to match strings to the effect/callback of the option (ex: add X gold)
		print("Execute effect: ", option.effect)
	if option.next_line_id != "":
		show_line(current_container.get_line_by_id(option.next_line_id))
	else:
		close_dialogue()

func clear_options() -> void:
	LineOptions.visible = false
	for child in LineOptions.get_children():
		child.queue_free()

func close_dialogue() -> void:
	self.visible = false
	current_line = null
	current_container = null
	dialogue_finished.emit()
