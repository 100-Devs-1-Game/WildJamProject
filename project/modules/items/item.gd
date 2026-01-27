class_name Item
extends Resource

@export var name: String
@export var flavor: String
@export var recycle_value: int

@export var icon: AtlasTexture
@export var icon_variants: int
@export var icon_variants_x: int
@export var icon_variants_y: int
@export var current_icon_variant: int
@export var fixed_icon_variant: int = 0


@export var model: PackedScene
@export var model_name: String # This is the node name under the root of "res://assets/3d/items/item_drops.tscn"


func randomize():
	assert (icon_variants == (icon_variants_x * icon_variants_y))
	if icon_variants > 1 and not fixed_icon_variant:
		current_icon_variant = randi_range(1, icon_variants)

func get_2d_texture() -> AtlasTexture:
	var new_icon := icon.duplicate()
	var icon_variant = current_icon_variant
	if fixed_icon_variant:
		icon_variant = fixed_icon_variant
	new_icon.region.position.x = icon.region.size.x * ((icon_variant - 1) % icon_variants_x) 
	new_icon.region.position.y = icon.region.size.y * ((icon_variant - 1) % icon_variants_y)
	return new_icon
	
