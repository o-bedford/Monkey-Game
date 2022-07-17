extends Control

var PlayerStats = get_parent().get_node("Player")


var hearts = 3 setget setHearts
var maxHearts = 3 setget setMaxHearts

onready var label = $Label

func setHearts(value):
	hearts = clamp(value, 0, maxHearts)
	
func setMaxHearts(value):
	maxHearts = max(value,1)
	
func _ready():
	self.maxHearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	
