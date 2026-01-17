class_name Level
extends Node2D

const CORPSE_ITEM_COUNT = 5
const NUM_GRASS_VARIATIONS = 3
const SAFE_ZONE_SOURCE_ID = 4

@export var size: Vector2i = Vector2i(50, 50)

@export var terrain: TileMapLayer
@export var terrain_border: TileMapLayer
@export var player_scene: PackedScene

var item_library = []
var player: IsometricPlayer
var safezones: Array[Vector2i]


func _ready() -> void:
	init_signals()
	
	build()
	assert(player_scene)
	var center := terrain.map_to_local(size / 2)
	spawn_enemies()
	spawn_player(terrain.map_to_local(find_nearest_walkable_tile(center)))
	
func init_signals():
	Signals.enemy_destroyed.connect(spawn_items_from_corpse)

func build():
	var force_safezone := false
	if Progress.safezone_state == Progress.SafezoneState.NO_SAFEZONE_FOUND:
		force_safezone = true
		while not Progress.first_safezone_pos:
			var rnd_pos := Vector2i(randi_range(1, size.x  - 2), randi_range(1, size.y  - 2))
			Progress.first_safezone_pos= rnd_pos
		safezones.append(Progress.first_safezone_pos)

	MazeGenerator.generate_maze(size.x, size.y, force_safezone, Progress.first_safezone_pos)
	
	for x in size.x:
		for y in size.y:
			var walkable: bool = MazeGenerator.map[x][y]
			var pos := Vector2i(x, y)
			terrain.set_cell(pos, randi() % NUM_GRASS_VARIATIONS, Vector2.ZERO)
			if not walkable:
				terrain_border.set_cell(pos, 0, Vector2i.ZERO)

	for tile in safezones:
		terrain.set_cell(tile, SAFE_ZONE_SOURCE_ID, Vector2i.ZERO)

func find_nearest_walkable_tile(pos: Vector2)-> Vector2i:
	var nearest = null
	for tile in terrain.get_used_cells():
		if tile in terrain_border.get_used_cells():
			continue
		if not nearest or pos.distance_to(terrain.map_to_local(tile)) < pos.distance_to(terrain.map_to_local(nearest)):  
			nearest= tile
	return nearest

func spawn_player(pos: Vector2):
	player = player_scene.instantiate()
	player.position = pos
	add_child(player)

func spawn_enemies():
	var enemies: Array[EnemyDefinition]
	var enemy_path := "res://data/enemies/"
	for res_file in ResourceLoader.list_directory(enemy_path):
		enemies.append(load(enemy_path + "/" + res_file))

	for tile in terrain.get_used_cells():
		if tile in terrain_border.get_used_cells():
			continue
		for enemy in enemies:
			if randf() * 100 < enemy.spawn_chance:
				spawn_enemy(enemy, tile)
				break

func spawn_enemy(enemy_def: EnemyDefinition, tile: Vector2i):
	assert(enemy_def.scene)
	var enemy: MazeEnemy = enemy_def.scene.instantiate()
	enemy.position= terrain.map_to_local(tile)
	add_child(enemy)

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
