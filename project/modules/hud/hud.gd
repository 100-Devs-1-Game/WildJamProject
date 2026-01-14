extends Node



# a health bar
@export var health_bar: ProgressBar
# a sanity bar
@export var sanity_bar: ProgressBar
# ammo counter
@export var ammo_count_label: Label
# weapon hotbar for weapon switching
@export var weapon_hotbar: Control

func _ready() -> void:
	Signals.change_health_value.connect(set_health_bar_value)
	Signals.change_sanity_value.connect(set_sanity_bar_value)
	Signals.change_ammo_count_value.connect(set_ammo_count_value)


func set_health_bar_value(current_amount: int, max_amount: int) -> void:
	health_bar.value = current_amount
	health_bar.max_value = max_amount

func set_sanity_bar_value(current_amount: float, max_amount: float) -> void:
	sanity_bar.value = current_amount
	sanity_bar.max_value = max_amount

func set_ammo_count_value(current_amount: int, max_amount: int) -> void:
	ammo_count_label.text = "%s/%s" % [current_amount, max_amount]
