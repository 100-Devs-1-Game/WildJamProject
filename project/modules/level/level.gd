class_name Level
extends Node2D

const CORPSE_ITEM_COUNT = 5
const BORDER_TILE_SOURCE_ID = 3

@export var size: Vector2i = Vector2i(50, 50)

@export var terrain: TileMapLayer
@export var player_scene: PackedScene

var item_library = []
var player: IsometricPlayer
var safezones: Array[Vector2i]


func _ready() -> void:
	init_signals()
	
	build()
	assert(player_scene)
	var center := terrain.map_to_local(size / 2)
	spawn_player(terrain.map_to_local(find_nearest_walkable_tile(center)))
	
func init_signals():
	Signals.enemy_destroyed.connect(spawn_items_from_corpse)

func build():
	MazeGenerator.generate_maze(size.x, size.y)
	for x in size.x:
		for y in size.y:
			var walkable: bool = MazeGenerator.map[x][y]
			var pos := Vector2i(x, y)
			terrain.set_cell(pos, randi() % BORDER_TILE_SOURCE_ID if walkable else BORDER_TILE_SOURCE_ID, Vector2.ZERO)

func find_nearest_walkable_tile(pos: Vector2)-> Vector2i:
	var nearest = null
	for tile in terrain.get_used_cells():
		if terrain.get_cell_tile_data(tile).get_custom_data("border"):
			continue
		if not nearest or pos.distance_to(terrain.map_to_local(tile)) < pos.distance_to(terrain.map_to_local(nearest)):  
			nearest= tile
	return nearest

func spawn_player(pos: Vector2):
	player = player_scene.instantiate()
	player.position = pos
	add_child(player)

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
