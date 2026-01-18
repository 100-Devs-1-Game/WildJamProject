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
		$Arm.get_node("SlotImage").texture = PlayerInventory.equipped_arm.get_2d_texture()
	if PlayerInventory.equipped_weapon:
		$Weapon.get_node("SlotImage").texture = PlayerInventory.equipped_weapon.get_2d_texture()
	if PlayerInventory.equipped_head:
		$Head.get_node("SlotImage").texture = PlayerInventory.equipped_head.get_2d_texture()
	if PlayerInventory.equipped_legs:
		$Legs.get_node("SlotImage").texture = PlayerInventory.equipped_legs.get_2d_texture()
	if PlayerInventory.equipped_torso:
		$Torso.get_node("SlotImage").texture = PlayerInventory.equipped_torso.get_2d_texture()
