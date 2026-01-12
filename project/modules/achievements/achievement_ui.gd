extends Control


# Visual node of the achievement
@export var achievement_visual_scene: PackedScene = preload("res://modules/achievements/achievement_visual.tscn")
# Node that visually organizes achievements if there are multiple
@export var achievements_list: VBoxContainer
# How long the achievement is shown on the screen, after that disappears
@export var achievement_show_time: float

func _ready() -> void:
	Signals.achievement_unlocked.connect(display_unlocked_achievement)

# Creates achievement node, adds it to the screen, adds a timer that will delete the node
func display_unlocked_achievement(achievement: AchievementData) -> void:
	var new_achievement: Control = achievement_visual_scene.instantiate()
	new_achievement.setup(achievement.achievement_name, achievement.achievement_image, achievement.achievement_description)
	achievements_list.add_child(new_achievement)
	# Remove the achievement after X seconds
	get_tree().create_timer(achievement_show_time).timeout.connect(new_achievement.queue_free)
