@tool
class_name ItemInstance
extends Node2D

var item_id:=-1
var tween: Tween

func _ready() -> void:
	$Area2D.connect("body_entered", body_entered)

func body_entered(body: Node2D):
	# TODO review if other entities (i.e. enemies) can pick up items, then we can change this logic
	if body.has_method("pickup_item"):
		body.pickup_item(self)
		destroy_item()
		
func destroy_item():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(mesh_instance, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(queue_free)


func load_item(item_id_:int):
	# Intentionally avoiding using setters here since the default values also trigger setter calls on initialization
	item_id = item_id_
	var item_library = preload("res://assets/3d/items/item_drops.tscn").instantiate()
	mesh_instance = item_library.get_child(item_id).duplicate()
	mesh_instance.position = Vector3.ZERO

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
