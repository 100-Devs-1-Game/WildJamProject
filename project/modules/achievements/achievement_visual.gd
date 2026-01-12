extends PanelContainer


@export var ach_name_label: Label
@export var ach_image: TextureRect
@export var ach_description_label: Label

func setup(ach_name: String, ach_image_texture: Texture, ach_description: String) -> void:
	ach_name_label.text = ach_name
	ach_image.texture = ach_image_texture
	ach_description_label.text = ach_description
