extends Control


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")
	
func _process(delta):
	if player.hearts == 3:
		$LifeFG.visible = true
		$LifeFG2.visible = true
		$LifeFG3.visible = true
	if player.hearts == 2:
		$LifeFG.visible = false
		$LifeFG2.visible = true
		$LifeFG3.visible = true
	if player.hearts == 1:
		$LifeFG.visible = false
		$LifeFG2.visible = false
		$LifeFG3.visible = true
