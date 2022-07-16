extends KinematicBody2D

var speed = 40
var velocity = Vector2.ZERO
var facing

export(int, "Fire", "Elec", "Rock", "Midas") var holding_power

var is_squashed
var squash_count = 0

func _ready():
	randomize()
	facing = -1
	holding_power = 1

func _process(delta):
	if squash_count > 2:
		queue_free()

func _physics_process(delta):
	velocity.y += 30
	if !is_squashed:
		velocity.x = speed * facing
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall():
		facing *= -1

func get_power():
	return holding_power

func squash():
	squash_count += 1
	is_squashed = true
	$Sprite.scale.y = 0.25
	velocity.x = 0
	yield(get_tree().create_timer(1), "timeout")
	$Sprite.scale.y = 1
	is_squashed = false
