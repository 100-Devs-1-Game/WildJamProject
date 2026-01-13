extends Node2D

@export var dialogue_container: DialogueContainer
var is_player_near: bool = false

func _ready() -> void:
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_near:
		if dialogue_container:
			var DialogueBox = DialogueManager.get_node("DialogueBox")
			if DialogueBox.current_container == null:
				DialogueBox.start_dialogue(dialogue_container)
			else:
				DialogueBox.on_next_pressed()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_near = false
