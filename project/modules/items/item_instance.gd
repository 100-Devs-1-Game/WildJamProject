@tool
class_name ItemInstance
extends Node2D

var item_id:=-1
var tween: Tween

# For the kick around logic, instead of relying on physics, we can use the tilemap and ensure the item is only moved onto valid tiles. 
var _coords: Vector2i
var _terrain: TileMapLayer
var _is_moving := false
const kick_animation_time = 0.15

var item_picker: Node2D

func _ready() -> void:
	$Label.hide()
	$PickupRangeArea2D.connect("body_entered", player_entered.bind(true))
	$PickupRangeArea2D.connect("body_exited", player_entered.bind(false))
	$KickRangeArea2D.connect("body_entered", kick_item)

func player_entered(body: Node2D, entered: bool):
	if body.has_method("pickup_item"):
		if entered:
			# TODO the player is in range, maybe we can highlight items in range?
			$Label.show()
			item_picker = body
		else:
			# TODO the player is not in range anymore
			$Label.hide()
			item_picker = null
			
func kick_item(body: Node2D):
	# See if we can kick the item around
	if not body.has_method("pickup_item"): 
		return
	# Check if the items is already being kicked to prevent glitches
	if _is_moving or not _terrain:
		return
	# Check player position to get which direction to kick to
	var kick_direction = Vector2i.ZERO
	if abs(body.position.x - position.x) > abs(body.position.y - position.y):
		if body.position.x < position.x:
			kick_direction.x = 1
		else:
			kick_direction.x = -1
	else:
		if body.position.y < position.y:
			kick_direction.y = 1
		else:
			kick_direction.y = -1
	var new_coords = _coords
	# First try to kick 2 cells away, if not possible, 1 cell away
	var can_kick = false
	if new_coords + kick_direction * 2 in _terrain.get_used_cells():
		new_coords += kick_direction * 2
		can_kick = true
	elif new_coords + kick_direction in _terrain.get_used_cells():
		new_coords += kick_direction
		can_kick = true
	if can_kick:
		# We can kick the item to that direction
		kick_item_animation(new_coords)
	else:
		# Stay in place
		pass

		
func kick_item_animation(new_coords: Vector2i):
	_coords = new_coords
	_is_moving = true
	var tween2 = create_tween()
	tween2.set_parallel(true)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUAD)
	var final_position = _terrain.map_to_local(new_coords) + _terrain.tile_set.tile_size * 0.5
	final_position += Utils.random_vec2(_terrain.tile_set.tile_size)
	final_position = _terrain.to_global(final_position)
	tween2.tween_property(self, "position", final_position, kick_animation_time)
	# Add a vertical arch to the sprite
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property($Sprite2D, "position:y", _terrain.tile_set.tile_size.x*-3.0, kick_animation_time * 0.5).as_relative()
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property($Sprite2D, "position:y", 0.0, kick_animation_time * 0.5).as_relative().set_delay(kick_animation_time * 0.5)
	tween2.chain()
	tween2.tween_callback(kick_item_animation_end)

func kick_item_animation_end():
	_is_moving = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action("interact") and event.is_pressed():
		pickup_item()

func pickup_item():
	if item_picker:
		item_picker.pickup_item(self)
		destroy_item()
		
func destroy_item():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Shadow, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_property(mesh_instance, "scale", Vector3.ZERO, 0.5)
	tween.chain()
	tween.tween_callback(queue_free)


func load_item(item_id_:int, coords: Vector2i=Vector2i.ZERO, terrain: TileMapLayer=null):
	# Intentionally avoiding using setters here since the default values also trigger setter calls on initialization
	item_id = item_id_
	var item_library = preload("res://assets/3d/items/item_drops.tscn").instantiate()
	mesh_instance = item_library.get_child(item_id).duplicate()
	mesh_instance.position = Vector3.ZERO
	# For keeping track of kicking logic
	_coords = coords
	_terrain = terrain

@export var mesh_instance: MeshInstance3D:
	set(m):
		mesh_instance = m
		if mesh_instance:
			$SubViewport.add_child(mesh_instance)
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property(mesh_instance, "position:y", -1.0, 1.0)
			tween.tween_property(mesh_instance, "position:y", 0.0, 1.0)
			tween.set_loops()
