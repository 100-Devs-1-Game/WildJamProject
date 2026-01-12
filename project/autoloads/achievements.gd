extends Node


# A list of all achievements that are already unlocked
var unlocked_achievements: Array[AchievementData]

func _ready() -> void:
	Signals.achievement_trigger.connect(check_achievement)

func check_achievement(new_achievement: AchievementData) -> void:
	if new_achievement not in unlocked_achievements:
		unlock_new_achievement(new_achievement)
	else:
		print(new_achievement.achievement_name, " already unlocked")

func unlock_new_achievement(new_achievement: AchievementData) -> void:
	unlocked_achievements.append(new_achievement)
	Signals.achievement_unlocked.emit(new_achievement)
	print(new_achievement.achievement_name, " now unlocked")
