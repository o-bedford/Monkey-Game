extends Control

func _ready():
	$ColorRect.color = Color(0,0,0,0)
	$AnimationPlayer.play("Fade In")
