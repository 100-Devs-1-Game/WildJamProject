extends Node2D

@export var item_num := 5
@export var terrain_reference: NodePath
var item_catalog_num := 0
var terrain: TileMapLayer

func _ready() -> void:
	item_catalog_num = preload("res://assets/3d/items/item_drops.tscn").instantiate().get_child_count()
	if terrain_reference:
		terrain = get_node_or_null(terrain_reference) as TileMapLayer
		spawn_items(item_num)
		
	Signals.enemy_destroyed.connect(spawn_items_from_corpse)
	
func spawn_items_from_corpse(enemy: MazeEnemy):
	if not terrain:
		return
	var coords = terrain.local_to_map(terrain.to_local(enemy.position)) 
	for i in item_num:
		spawn_item(coords, randi() % item_catalog_num)

func spawn_items(item_num_: int):
	for i in item_num_:
		var coords = terrain.get_used_cells().pick_random()
		spawn_item(coords, randi() % item_catalog_num)


func spawn_item(coords: Vector2i, item_id: int):
	if not terrain:
		return
	var item := preload("res://modules/items/item_instance.tscn").instantiate() as ItemInstance
	item.load_item(item_id, coords, terrain)
	add_child.call_deferred(item)
	# Items are centered, we need to add half the cell size to center them on the selected tile
	item.position = terrain.map_to_local(coords) + terrain.tile_set.tile_size * 0.5
	# Add a random offset
	item.position += Utils.random_vec2(terrain.tile_set.tile_size)
	# Since the scale of the terrain layer is 2x, we need to scale the item positions as well.
	item.position = terrain.to_global(item.position)
	# Add some animation when spawning an item
	item.kick_item_animation(coords)
