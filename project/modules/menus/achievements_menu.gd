extends Control

@export var achievements: AchievementsList

@onready var close_button: Button = %CloseButton
@onready var achievement_list: ItemList = %AchievementList
@onready var achievement_name: Label = %AchievementName
@onready var achivement_flavor: Label = %AchivementFlavor


func _ready() -> void:
	close_button.pressed.connect(get_tree().quit)
	assert(achievements is AchievementsList)
	for a:AchievementData in achievements.list.keys():
		achievement_list.add_item(a.name)
	achievement_list.item_selected.connect(_on_item_list_selected)


func _on_item_list_selected(index: int) -> void:
	var a:AchievementData = achievements.list.keys()[index]
	#var player_has: bool = achievements.list[a]
	achievement_name.text = a.name
	achivement_flavor.text = a.flavor
	
