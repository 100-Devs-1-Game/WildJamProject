extends Node

enum TargetScene { MAIN, HUB, GAME }

@export var targetScene: TargetScene = TargetScene.MAIN

func _on_pressed() -> void:
	match targetScene:
		TargetScene.MAIN:
			SceneManager.load_main_menu_scene();
		TargetScene.HUB:
			SceneManager.load_hub_scene();
		TargetScene.GAME:
			SceneManager.load_game_scene();
