extends Area2D

const SPEED = 800
var velocity = Vector2()
var direction = 1

func _ready():
	pass # Replace with function body.
	
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

# fireball movement
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("fire")

# handling interations with bodies
func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemies"):
		queue_free()
		body.burn()
	else:
		queue_free()

# destroy fireball when it exits screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
