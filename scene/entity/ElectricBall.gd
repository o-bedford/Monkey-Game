extends RigidBody2D

var direction

func _ready():
	pass

func _on_ElectricBall_body_entered(body):
#	print(body.name)
	if body.has_method("get_power") and !body.is_shocked:
		queue_free()
		body.shock()
	if body.name == "TileMap":
		queue_free()

func set_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true
