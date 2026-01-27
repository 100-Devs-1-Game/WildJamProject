class_name  PlayerDoll
extends Node2D

func _ready() -> void:
	hide()
	_update_icons()
	Signals.inventory_updated.connect(_update_icons)
	PlayerInventory.generate_new_android_inventory_if_empty()
	

func _on_generate_pressed() -> void:
	PlayerInventory.generate_new_android_inventory() # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_inventory"):
		if visible:
			hide()
		else:
			show()

func _update_icons() -> void:
	if PlayerInventory.equipped_arm:
		$Arm.item = PlayerInventory.equipped_arm
	if PlayerInventory.equipped_weapon:
		$Weapon.item = PlayerInventory.equipped_weapon
	if PlayerInventory.equipped_head:
		$Head.item = PlayerInventory.equipped_head
	if PlayerInventory.equipped_legs:
		$Legs.item = PlayerInventory.equipped_legs
	if PlayerInventory.equipped_torso:
		$Torso.item = PlayerInventory.equipped_torso
	if SceneManager.player_in_hub():
		$GearsDisplay/Label.text = str(PlayerInventory.skyscraper_gears)
	else:
		$GearsDisplay/Label.text = str(PlayerInventory.maze_gears)
