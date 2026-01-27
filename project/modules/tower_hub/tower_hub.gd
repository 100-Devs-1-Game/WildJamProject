extends Node

func _ready():
	$Shop.hide()
	$SkyScraperUpgrade.hide()
	$OpenShop.pressed.connect(_open_shop)
	$OpenSkyscraper.pressed.connect(_open_skyscraper)

func _open_shop() -> void:
	$Shop.show()
	$SkyScraperUpgrade.hide()
	
func _open_skyscraper() -> void:
	$Shop.hide()
	$SkyScraperUpgrade.show()
