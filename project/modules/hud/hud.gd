extends Node



# a health bar
@export var health_bar: ProgressBar
# a sanity bar
@export var sanity_bar: ProgressBar
# ammo counter
@export var ammo_count_label: Label
# weapon hotbar for weapon switching
# ... todo

var curr_ammo = 40
var curr_health = 100.0
var curr_sanity = 100.0

func _ready() -> void:
	Signals.change_health_value.connect(set_health_bar_value)
	Signals.change_sanity_value.connect(set_sanity_bar_value)
	Signals.change_ammo_count_value.connect(set_ammo_count_value)

func set_health_bar_value(current_amount: float) -> void:
	health_bar.value = current_amount

func set_sanity_bar_value(current_amount: float) -> void:
	sanity_bar.value = current_amount

func set_ammo_count_value(current_amount: int, max_amount: int) -> void:
	ammo_count_label.text = "%s/%s" % [current_amount, max_amount]

# For debug currently
func _on_timer_timeout() -> void:
	curr_health -= 1.5
	curr_sanity -= 3.0
	curr_ammo -= 1
	Signals.change_health_value.emit(curr_health)
	Signals.change_sanity_value.emit(curr_sanity)
	Signals.change_ammo_count_value.emit(curr_ammo, 40)
