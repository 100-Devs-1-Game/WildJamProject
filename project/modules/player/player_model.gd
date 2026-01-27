extends Node2D

func _ready():
	_update_textures()
	Signals.inventory_updated.connect(_update_textures)
	
func _update_textures():
	$Leg.texture = null
	if PlayerInventory.equipped_legs:
		$Leg.texture = PlayerInventory.equipped_legs.get_2d_texture()
	
	$Torso.texture = null
	if PlayerInventory.equipped_torso:
		$Torso.texture = PlayerInventory.equipped_torso.get_2d_texture()
	
	$Shoulder/Arm.texture = null
	if PlayerInventory.equipped_arm:
		$Shoulder/Arm.texture = PlayerInventory.equipped_arm.get_2d_texture()
	
	$Shoulder/Arm/Weapon/Sprite2D.texture = null
	if PlayerInventory.equipped_weapon:
		$Shoulder/Arm/Weapon/Sprite2D.texture = PlayerInventory.equipped_weapon.get_2d_texture()
	
	$Head.texture = null
	if PlayerInventory.equipped_head:
		$Head.texture = PlayerInventory.equipped_head.get_2d_texture()
