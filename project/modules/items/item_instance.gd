@tool
class_name ItemInstance
extends Node2D

@export var mesh_instance: MeshInstance3D:
	set(m):
		mesh_instance = m
		if mesh_instance:
			var tween := create_tween()
			tween.tween_property(mesh_instance, "position:y", -1.0, 1.0)
			tween.tween_property(mesh_instance, "position:y", 0.0, 1.0)
			tween.set_loops()
