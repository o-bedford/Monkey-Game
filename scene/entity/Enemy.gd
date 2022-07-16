extends KinematicBody2D

var speed = 60
var velocity = Vector2.ZERO
var facing

export(int, "Fire", "Elec", "Rock", "Midas") var holding_power

var is_squashed
var squash_count = 0
var player
var see_player = false

var is_burning
const BURN = preload("res://scene/entity/Burn.tscn")

func _ready():
	print(str(holding_power))
	player = get_parent().get_node("Player")
	randomize()
	facing = -1

func _process(delta):
	if squash_count > 2:
		queue_free()

func _physics_process(delta):
	set_facing()
	if !is_on_floor():
		velocity.y += 30
	if !is_squashed and is_on_floor():
		velocity.x = speed * facing
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall() and !see_player:
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
	
func burn():
	if !is_burning:
		is_burning = true
		var burn_sprite = Sprite.new()
		burn_sprite.texture = load("res://assets/img/entity/enemies/fireTEMP.png")
#		var burn = BURN.instance()
#		get_parent().add_child(burn)
		add_child(burn_sprite)
#		burn.position = $Position2D.global_position
		yield(get_tree().create_timer(5), "timeout")
		is_burning = false
		remove_child(burn_sprite)
#		get_parent().remove_child(burn)

func set_facing():
	if player.get_node("Walkbox").global_position.x < $CollisionShape2D.global_position.x - 22:
		if $CollisionShape2D.global_position.x - player.get_node("Walkbox").global_position.x < 300:
#			print("enemy pos: " + str($CollisionShape2D.global_position.x) + "player pos: " + str(player.get_node("Walkbox").global_position.x))
			facing = -1
			see_player = true
		else:
			see_player = false
#		print("in range! left")
	elif player.get_node("Walkbox").global_position.x > $CollisionShape2D.global_position.x - 22:
		if player.get_node("Walkbox").global_position.x - $CollisionShape2D.global_position.x < 300:
			facing = 1
			see_player = true
		else:
			see_player = false
#		print("in range! right")
	else:
		see_player = false
