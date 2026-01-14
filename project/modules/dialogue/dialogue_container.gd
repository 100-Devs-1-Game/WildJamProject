extends Resource
class_name DialogueContainer

@export var start_id: String = "start"
@export var lines: Array[DialogueLine]

func get_line_by_id(target_id: String) -> DialogueLine:
	for line in lines:
		if line.id == target_id:
			return line
	return null
