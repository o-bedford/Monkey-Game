extends KinematicBody2D

var speed = 40
var velocity = Vector2.ZERO
var facing

export(int, "Fire", "Elec", "Rock", "Midas") var holding_power

func _ready():
	randomize()
	facing = -1
	holding_power = 1

func _physics_process(delta):
	if !is_on_wall():
		velocity.x = speed * facing
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall():
		facing *= -1

func get_power():
	return holding_power
