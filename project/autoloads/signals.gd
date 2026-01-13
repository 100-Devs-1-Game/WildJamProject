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
