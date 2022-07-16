extends Node

const FADE_CONST = 1
var fade_val = 0
var fade = false;

func _ready():
	$"Roll Fade".color = Color(0, 0, 0, 0)

func _process(delta):
	if Input.is_action_just_pressed("steal_attack"):
		fade = true
	if fade_val < 0.5 && fade:
		fade_val += FADE_CONST * delta
		$"Roll Fade".color = Color(0, 0, 0, fade_val)
	else:
		fade = false
