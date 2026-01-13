extends Node2D

@export var item_num := 50
@export var terrain_reference: NodePath
var terrain: TileMapLayer

func _ready() -> void:
	if terrain_reference:
		terrain = get_node_or_null(terrain_reference) as TileMapLayer
		spawn_items(item_num)


func spawn_items(item_num_: int):
	for i in item_num_:
		var coords = terrain.get_used_cells().pick_random()
		spawn_item(coords, randi() % 10)
			
func spawn_item(coords: Vector2i, item_id: int):
	if not terrain:
		return
	var item := preload("res://modules/items/item_instance.tscn").instantiate() as ItemInstance
	item.load_item(item_id)
	add_child(item)
	# Items are centered, we need to add half the cell size to center them on the selected tile
	item.position = terrain.map_to_local(coords) + terrain.tile_set.tile_size * 0.5
	# Since the scale of the terrain layer is 2x, we need to scale the item positions as well.
	item.position *= terrain.scale
