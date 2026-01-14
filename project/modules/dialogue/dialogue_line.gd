extends Resource
class_name DialogueLine

@export var id: String
@export var speaker_name: String
@export var speaker_image: Texture2D
@export_multiline var text: String
@export var options: Array[DialogueOption]
@export var next_line_id: String # used only if the line has no options
