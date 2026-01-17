extends Node

## --- public vars ---
var current_scene: Node = null

## --- export vars ---
@export var main_menu_scene: PackedScene
@export var credits_scene: PackedScene
@export var hub_scene: PackedScene
@export var game_scene: PackedScene

## --- default methods ---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_main_menu_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## --- public methods ---

## Changes the room
func change_room(scene: PackedScene) -> void:
	# Remove current room
	if current_scene and is_instance_valid(current_scene):
		current_scene.queue_free()
		
	# Load new room
	current_scene = scene.instantiate()
	add_child(current_scene)
	
	# Send signal
	Signals.scene_change.emit()

## Loads game scene
func load_game_scene():
	change_room(game_scene)

## Loads the hub scene
func load_hub_scene():
	change_room(hub_scene)

## Loads the main menu scene
func load_main_menu_scene():
	change_room(main_menu_scene)
	
## Loads the cradits scene
func load_credits_scene():
	change_room(credits_scene)
