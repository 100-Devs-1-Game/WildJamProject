extends Node



func _ready() -> void:
	pass


func _on_play_button_pressed() -> void:
	SceneManager.load_hub_scene()


func _on_settings_button_pressed() -> void:
	pass


func _on_credits_button_pressed() -> void:
	SceneManager.load_credits_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
