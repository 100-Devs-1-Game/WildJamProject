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
