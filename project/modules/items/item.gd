class_name Item
extends Resource

@export var name: String
@export var flavor: String

@export var icon: AtlasTexture
@export var icon_variants: int
@export var current_icon_variant: int

@export var model: PackedScene
@export var model_name: String # This is the node name under the root of "res://assets/3d/items/item_drops.tscn"
