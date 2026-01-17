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

var inventory: Dictionary[Item, int]
var equipped_head: Upgrade
var equipped_torso: Upgrade
var equipped_legs: Upgrade
var equipped_arm: Upgrade
var equipped_weapon: Weapon


func _ready() -> void:
	Signals.item_picked_up.connect(add_item.bind(1))
	

func generate_new_android_inventory() -> void:
	equipped_head = load(item_library["heads"].pick_random()).duplicate()
	equipped_head.randomize()
	equipped_torso = load(item_library["torsos"].pick_random()).duplicate()
	equipped_torso.randomize()
	equipped_legs = load(item_library["legs"].pick_random()).duplicate()
	equipped_legs.randomize()
	equipped_arm = load(item_library["arms"].pick_random()).duplicate()
	equipped_arm.randomize()
	var new_weapon = item_library["weapons"].pick_random()
	print(new_weapon)
	equipped_weapon = load(new_weapon).duplicate()
	equipped_weapon.randomize()
	Signals.inventory_updated.emit()
	

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
