extends Control

func _ready():
	$ColorRect.color = Color(0,0,0,0)
	$AnimationPlayer.play("Fade In")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade In":
		yield(get_tree().create_timer(2), "timeout")
		$AnimationPlayer.play("Fade Out")
	if anim_name == "Fade Out":
		get_parent().get_node("Player").can_move = true
