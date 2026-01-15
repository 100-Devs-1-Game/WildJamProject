class_name  PlayerInventory
extends Node2D

const item_library = [
	"res://data/items/blunderbuss.tres",
	"res://data/items/katana.tres",
	"res://data/items/polearm.tres",
]

@export var row_count: int
@export var column_count: int

var inventory: Dictionary[Item, int]
var equipped_head: Item
var equipped_torso: Item
var equipped_legs: Item
var equipped_weapon: Weapon

func _ready() -> void:
	hide()
	Signals.item_picked_up.connect(add_item.bind(1))
	

func generate_new_android_inventory() -> void:
	pass

func add_item(item: Item, count: int) -> void:
	if item in inventory:
		inventory[item] += count
	else:
		inventory[item] = count
	prints("The player picked up the item with name:", item.model_name, "the player now has:", inventory)
	var weapons: Array[Weapon]
	for i in inventory:
		if i is Weapon and i not in weapons:
			weapons.append(i)
	Signals.weapon_update.emit(weapons)

func remove_item(item: Item, count: int) -> void:
	inventory[item] -= count
	if inventory[item] <= 0:
		inventory.erase(item)
	
	
func render_inventory():
	show()


func _on_generate_pressed() -> void:
	generate_new_android_inventory() # Replace with function body.
