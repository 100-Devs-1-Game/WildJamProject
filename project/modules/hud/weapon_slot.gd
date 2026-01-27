class_name WeaponSlot
extends Control

@onready var WeaponSlotScene = preload("res://modules/hud/weapon_slot.tscn")

@export var slot_texture: Texture2D

var item: Item:
	set(new_item):
		item = new_item
		if is_node_ready():
			if item:
				$SlotImage.texture = item.get_2d_texture()
			else:
				$SlotImage.texture = null

func _ready() -> void:
	if item:
		$SlotImage.texture = item.get_2d_texture()
	if slot_texture:
		$SlotImage.texture = slot_texture
	
func _get_drag_data(_pos):
	if not PlayerInventory.can_drag_item(item):
		return
	var weapon_slot = WeaponSlotScene.instantiate()
	weapon_slot.item = item
	weapon_slot.size = size
	set_drag_preview(weapon_slot)
	return {
		"item": item.duplicate(),
		"source_item": item,
	}

func _can_drop_data(pos, data):
	var global_pos = pos + global_position
	return PlayerInventory.can_drop_item(global_pos, data["item"])

func _drop_data(pos, data):
	var global_pos = pos + global_position
	PlayerInventory.drop_item(
		global_pos, data["item"], data["source_item"])
