extends CanvasLayer

signal transitioned

func _ready():
	transition()
	$VBoxContainer/try_again.grab_focus()
	
func transition():
	$AnimationPlayer.play("fade_to_black")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
		
	if anim_name == "fade_to_normal":
		print("finished fading")



func _on_Try_again_pressed():
	get_tree().change_scene("res://scene/level/Test_Movement.tscn")


func _on_Quit_game_pressed():
	get_tree().quit()
