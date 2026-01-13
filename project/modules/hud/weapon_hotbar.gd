extends Control


@export var weapons_hotbar_list: HBoxContainer
@onready var weapon_slot_scene: PackedScene = preload("res://modules/hud/weapon_slot.tscn")

# Populate the hotbar with all items in same order
func populate_hotbar(weapons: Array[Weapon]) -> void:
	for weapon in weapons_hotbar_list.get_children():
		weapon.queue_free()
	for weapon in weapons:
		var new_weapon_slot: Control = weapon_slot_scene.instantiate()
		new_weapon_slot.get_node("SlotImage").texture = weapon.icon
		new_weapon_slot.get_node("SlotFrame").visible = false
		weapons_hotbar_list.add_child(new_weapon_slot)
	select_item(0)

# Hightlight the currentlty selected item by showing a frame around it
func select_item(idx: int) -> void:
	for weapon in weapons_hotbar_list.get_children():
		weapon.get_node("SlotFrame").visible = false
	weapons_hotbar_list.get_child(idx).get_node("SlotFrame").visible = true

# Change out an item on certain idx
func change_item_on_idx(idx: int, new_weapon: Weapon) -> void:
	weapons_hotbar_list.get_child(idx).get_node("SlotImage").texture = new_weapon.icon
