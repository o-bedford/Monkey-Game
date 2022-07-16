extends Control

var hearts_size: int = 50
func _on_Player_life_changed(player_hearts: float) -> void:
	$Hearts.rect_size.x = player_hearts * hearts_size
