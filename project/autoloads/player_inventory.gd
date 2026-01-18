extends Node

const item_library = {
	"weapons": [
		"res://data/items/blunderbuss.tres",
		"res://data/items/katana.tres",
		"res://data/items/polearm.tres",
	],
	"heads": [
		"res://data/items/android_head.tres",	
	],
	"torsos": [
		"res://data/items/android_torso.tres",	
	],
	"arms": [
		"res://data/items/android_arm.tres",	
	],
	"legs": [
		"res://data/items/android_leg.tres",	
	],
}

var flattened_item_library: Array[Item]
var inventory: Dictionary[Item, int]
var equipped_head: Upgrade
var equipped_torso: Upgrade
var equipped_legs: Upgrade
var equipped_arm: Upgrade
var equipped_weapon: Weapon


func _ready() -> void:
	Signals.item_picked_up.connect(add_item.bind(1))
	for item_scenes in item_library.values():
		for item_scene in item_scenes:
			flattened_item_library.append(load(item_scene))
	print(flattened_item_library)

func generate_new_android_inventory() -> void:
	equipped_head = load(item_library["heads"].pick_random()).duplicate()
	equipped_head.randomize()
	equipped_torso = load(item_library["torsos"].pick_random()).duplicate()
	equipped_torso.randomize()
	equipped_legs = load(item_library["legs"].pick_random()).duplicate()
	equipped_legs.randomize()
	equipped_arm = load(item_library["arms"].pick_random()).duplicate()
	equipped_arm.randomize()
	equipped_weapon = load(item_library["weapons"].pick_random()).duplicate()
	equipped_weapon.randomize()
	Signals.inventory_updated.emit()

func generate_new_android_inventory_if_empty() -> void:
	if not (equipped_head and equipped_arm and equipped_torso and equipped_legs and equipped_weapon):
		generate_new_android_inventory()
	

func add_item(item: Item, count: int) -> void:
	if item in inventory:
		inventory[item] += count
	else:
		inventory[item] = count
	prints("The player picked up the item with name:", item.name, "the player now has:", inventory)
	Signals.inventory_updated.emit()


func remove_item(item: Item, count: int) -> void:
	inventory[item] -= count
	if inventory[item] <= 0:
		inventory.erase(item)
	Signals.inventory_updated.emit()

func can_drag_item(item: Item) -> bool:
	return item in inventory

func can_drop_item(pos: Vector2, item: Item):
	var inventory_slots = get_tree().get_nodes_in_group("inventory_slots")
	
	for slot in inventory_slots:
		if slot.get_global_rect().has_point(pos):
			return false
	var weapon_slot =  get_tree().get_nodes_in_group("weapon_slot")[0]
	if item is Weapon and weapon_slot.get_global_rect().has_point(pos):
		return true
	if item is Upgrade:
		var slot
		match item.type:
			Upgrade.Type.LEGS:
				slot =  get_tree().get_nodes_in_group("legs_slot")[0]
			Upgrade.Type.ARMS:
				slot =  get_tree().get_nodes_in_group("arm_slot")[0]
			Upgrade.Type.HEAD:
				slot =  get_tree().get_nodes_in_group("head_slot")[0]
			Upgrade.Type.TORSO:
				slot =  get_tree().get_nodes_in_group("torso_slot")[0]
		return slot.get_global_rect().has_point(pos)
	return false

func equip_item(item: Item) -> void:
	if item is Weapon:
		equipped_weapon = item
	else:
		match item.type:
			Upgrade.Type.LEGS:
				equipped_legs = item
			Upgrade.Type.ARMS:
				equipped_arm = item
			Upgrade.Type.HEAD:
				equipped_head = item
			Upgrade.Type.TORSO:
				equipped_torso = item
			Weapon.Type:
				equipped_weapon = item
	Signals.inventory_updated.emit()
			

	
