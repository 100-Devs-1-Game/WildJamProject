extends Control


@export var weapons_hotbar_list: HBoxContainer
@onready var weapon_slot_scene: PackedScene = preload("res://modules/hud/weapon_slot.tscn")

func _ready() -> void:
	Signals.inventory_updated.connect(populate_hotbar)

# Populate the hotbar with all items in same order
func populate_hotbar() -> void:
	var inventory = PlayerInventory.inventory.keys()
	for idx in min(len(inventory), len(weapons_hotbar_list.get_children())):
		weapons_hotbar_list.get_child(idx).item = inventory[idx]
	select_item(0)

# Hightlight the currentlty selected item by showing a frame around it
func select_item(idx: int) -> void:
	for weapon in weapons_hotbar_list.get_children():
		weapon.get_node("SlotFrame").visible = false
	weapons_hotbar_list.get_child(idx).get_node("SlotFrame").visible = true

# Change out an item on certain idx
func change_item_on_idx(idx: int, new_weapon: Weapon) -> void:
	weapons_hotbar_list.get_child(idx).item = new_weapon
