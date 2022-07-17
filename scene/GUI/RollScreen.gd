extends Control

var fire_tex = preload("res://assets/img/GUI/fireTEMP.png")
var elec_tex = preload("res://assets/img/entity/player/elecballTEMP.png")
var no_power = preload("res://assets/img/GUI/noPowerTEMP.png")

func _ready():
	$ColorRect.color = Color(0,0,0,0)
	$"Background Anim".play("Fade In")
	$Dice/Power.visible = false
	$Dice/Dice.visible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade In":
		$Dice/Dice.visible = true
		$DiceRoll.play("d4Roll")
		show_power()
	if anim_name == "Fade Out":
		get_parent().get_parent().get_node("Player").can_move = true
		$Dice/Dice.visible = false
		$Dice/Power.visible = false

func set_power(power):
	if power == -1:
		$Dice/Power.texture = no_power
	if power == 0:
		$Dice/Power.texture = fire_tex
	if power == 1:
		$Dice/Power.texture = elec_tex

func _on_DiceRoll_animation_finished(anim_name):
	if anim_name == "d4Roll":
		$"Background Anim".play("Fade Out")


func _on_Power_Anim_animation_finished(anim_name):
	$Dice/Power.visible = false

func show_power():
	$Dice/Power.visible = true
	yield(get_tree().create_timer(1), "timeout")
	$"Power Anim".play("Power Pop")
