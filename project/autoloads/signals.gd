extends Node

@warning_ignore_start("unused_signal")

## Emitted when a scene change is completed
signal scene_change()
## Emitted when something wants to trigger an achievement
signal achievement_trigger(achievement: AchievementData)
## Emitted when achievement has passed checks and has been unlocked
signal achievement_unlocked(thing: AchievementData)
## Emitted when an enemy is killed/destroyed
signal enemy_destroyed(enemy: MazeEnemy)
## Emitted when health value changes
signal change_health_value(current_amount: float, max_amount: float)
## Emitted when sanity value changes
signal change_sanity_value(current_amount: float, max_amount: float)
## Emitted when ammo count changes
signal change_ammo_count_value(current_amount: int, max_amount: int)
## Emitted when the weapon hotbar needs to be updated
signal weapon_update(weapons: Array[Weapon])
