class_name Level
extends Node2D

const CORPSE_ITEM_COUNT = 5

@export var terrain: TileMapLayer

var item_library = []


func _ready() -> void:
	Signals.enemy_destroyed.connect(spawn_items_from_corpse)

func spawn_items_from_corpse(enemy: MazeEnemy):
	if not terrain:
		return
	var coords = terrain.local_to_map(terrain.to_local(enemy.position)) 
	for i in CORPSE_ITEM_COUNT:
		spawn_item(coords, item_library.pick_random())

func spawn_items(item_num: int):
	for i in item_num:
		var coords = terrain.get_used_cells().pick_random()
		spawn_item(coords, item_library.pick_random())


func spawn_item(coords: Vector2i, item_structure: Item):
	if not terrain:
		return
	var item := preload("res://modules/items/item_instance.tscn").instantiate() as ItemInstance
	item.load_item(item_structure, coords, terrain)
	add_child.call_deferred(item)
	# Items are centered, we need to add half the cell size to center them on the selected tile
	item.position = terrain.map_to_local(coords) + terrain.tile_set.tile_size * 0.5
	# Add a random offset
	item.position += Utils.random_vec2(terrain.tile_set.tile_size)
	# Since the scale of the terrain layer is 2x, we need to scale the item positions as well.
	item.position = terrain.to_global(item.position)
	# Add some animation when spawning an item
	item.kick_item_animation(coords)
