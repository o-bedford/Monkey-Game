extends KinematicBody2D

var speed = 60
var velocity = Vector2.ZERO
var facing
var health = 3

var holding_power = 0

var is_squashed
var squash_count = 0
var player
var see_player = false
var can_attack = true

var is_burning = false
const BURN = preload("res://scene/entity/Burn.tscn")

var midas_state = false

var is_shocked = false

var FIREBALL = preload("res://scene/entity/Fireball.tscn")
var ELECTRIC_BALL = preload("res://scene/entity/ElectricBall.tscn")

var launching = false

var t = 0.0
var target

func _ready():
	$AnimationPlayer.play("run")
	print(str(holding_power))
	player = get_parent().get_node("Player")
	randomize()
	facing = -1

func _process(delta):
	if midas_state == true:
		velocity = Vector2.ZERO
	if health <= 0:
		$AnimationPlayer.play("death")
	if see_player and !launching:
		launching = true
		velocity.x = 0
		var fireball = FIREBALL.instance()
		fireball.set_fireball_direction(facing)
		fireball.set_collision_mask_bit(3, false)
		fireball.set_collision_mask_bit(2, true)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		yield(get_tree().create_timer(2), "timeout")
		launching = false
	if facing == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func _physics_process(delta):
	set_facing()
	if !is_on_floor() && !$CollisionShape2D.disabled:
		velocity.y += 30
	if !is_squashed and is_on_floor():
		velocity.x = speed * facing
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall() and !see_player:
		facing *= -1

func get_power():
	return holding_power

func burn():
	if !is_burning:
		$AnimationPlayer.play("hurt")
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

func shock():
	if !is_shocked:
		$AnimationPlayer.play("hurt")
		speed = 0
		is_shocked = true
		can_attack = false
		var shock_sprite = Sprite.new()
		shock_sprite.texture = load("res://assets/img/entity/enemies/electricityTEMP.png")
		add_child(shock_sprite)
		yield(get_tree().create_timer(2), "timeout")
		can_attack = true
		speed = 60
		is_shocked = false
		remove_child(shock_sprite)

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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		modulate = Color(1,1,1,0)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,0)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(.05), "timeout")
		queue_free()
	if anim_name == "hurt":
		$AnimationPlayer.play("run")
		$CollisionShape2D.disabled = false


func _on_Shock_Field_body_entered(body):
	if body.has_method("shock") && is_shocked && !body.is_shocked:
		if body.get_node("VisibilityNotifier2D").is_on_screen():
			var second_shock = ELECTRIC_BALL.instance()
			second_shock.position = $CollisionShape2D.global_position
			get_parent().add_child(second_shock)
			second_shock.linear_velocity = Vector2(12000 * cos(get_angle_to(body.position)), 12000 * sin(get_angle_to(body.position)))


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "hurt":
		$CollisionShape2D.disabled = true
		health -= 1
		speed = 0
		modulate = Color(1,1,1,0)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,0)
		yield(get_tree().create_timer(.05), "timeout")
		modulate = Color(1,1,1,1)
		speed = 60

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$AttackDetector.monitoring = false

func start_walk(): 
	$AnimationPlayer.play("run")
