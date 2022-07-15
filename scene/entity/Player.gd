extends KinematicBody2D

export var GRAVITY = 30

var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -900
	
	velocity = move_and_slide(velocity, Vector2.UP)
