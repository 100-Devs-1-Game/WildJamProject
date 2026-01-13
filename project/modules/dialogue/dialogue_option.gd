extends Resource
class_name DialogueOption

@export var text: String
@export var next_line_id: String

# Use if the chosen option has side-effects/callbacks (add item, remove gold, etc)
# (The effect string should match definitions on dialogue.gd)
@export var effect: String 
