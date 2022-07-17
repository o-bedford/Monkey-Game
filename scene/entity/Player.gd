extends KinematicBody2D

export var GRAVITY = 30
export var JUMP_SPEED = -900
const WALK_SPEED = 100

export(int, "d4", "d6", "d8", "d10") var dice_size

signal life_changed(player_hearts)
var max_hearts: int = 3
var hearts: float = max_hearts

var normal_tex = load("res://assets/img/entity/player/playerTEMP.png")
var hit_tex = load("res://assets/img/entity/player/playerTEMPHIT.png")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var knockback_speed = 300
var knockback_direction = Vector2.ZERO
var canJumpButMightNotBeTouchingGround = true
var jumpJustPressed = false
var hitCanBePressed = true
var can_move = true
var can_roll = false
var on_ground = false

var active_power

var enemies_has_hit = []

var dice_powers
var last_slot = 0
var Dice1
var Dice2
var Dice3
var FIREBALL = preload("res://scene/entity/Fireball.tscn")
var ELECTRIC_BALL = preload("res://scene/entity/ElectricBall.tscn")
var ROCK = preload("res://assets/img/entity/player/rockTEMP.png")
# remove later maybe
var default = preload("res://assets/img/entity/player/playerTEMP.png") 

var is_rock = false

func _ready():
	if dice_size == 0:
		dice_powers = [-1,-1,-1,-1]
	elif dice_size == 1:
		dice_powers = [-1,-1,-1,-1,-1,-1]
	elif dice_size == 2:
		dice_powers = [-1,-1,-1,-1,-1,-1,-1,-1]
	elif dice_powers == 3:
		dice_powers = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
	$"Hitbox/Hit Shape".disabled = true
	emit_signal("life_changed", max_hearts)
	
func _process(delta):
	if dice_powers.size() > 6:
		dice_powers.remove(0)
	if $"Hitbox/Hit Shape".disabled == false:
		for body in $Hitbox.get_overlapping_bodies():
			print(body.name)
			if "Enemy" in body.name:
				print("overlap")
				if !enemies_has_hit.has(body):
					if last_slot < dice_powers.size():
						dice_powers[last_slot] = body.get_power()
						last_slot += 1
					else:
						dice_powers.remove(0)
						dice_powers.append(body.get_power())
					can_roll = true
				body.get_node("AnimationPlayer").play("hurt")
				enemies_has_hit.append(body)

func _physics_process(delta):
	
	# Movement code
	if is_on_floor() && can_move:
		canJumpButMightNotBeTouchingGround = true
		if jumpJustPressed:
			velocity.y = JUMP_SPEED
		can_roll = true
	
	if !is_on_floor():
		can_roll = false
		if can_move:
			coyoteTime()
			velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("ui_up") and can_move:
		jumpJustPressed = true;
		rememberJumpTime()
		if canJumpButMightNotBeTouchingGround:
			velocity.y = JUMP_SPEED
	
	if Input.is_action_pressed("ui_left") and can_move:
		$Hitbox.scale.x = -1
		$"Player Sprite".flip_h = true
		velocity.x -= WALK_SPEED
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		
	if Input.is_action_pressed("ui_right") and can_move:
		$Hitbox.scale.x = 1
		$"Player Sprite".flip_h = false
		velocity.x += WALK_SPEED
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	
	if can_move:
		velocity = move_and_slide(velocity + knockback, Vector2.UP)
	
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	velocity.x = lerp(velocity.x, 0, 0.2)

func _input(event):
	# If the player is able to cube smash, do it. Hide dice face sprites, apply hit texture, wait a bit, and reset
	if event.is_action_pressed("steal_attack") and hitCanBePressed and is_on_floor():
		$"Hitbox/Hit Shape".disabled = false
		hitCanBePressed = false
		if Dice1 is Sprite:
			Dice1.visible = false
		if Dice2 is Sprite:
			Dice2.visible = false
		if Dice3 is Sprite:
			Dice3.visible = false
		$"Player Sprite".texture = hit_tex
		yield(get_tree().create_timer(0.4), "timeout")
		$"Player Sprite".texture = normal_tex
		if Dice1 is Sprite:
			Dice1.visible = true
		if Dice2 is Sprite:
			Dice2.visible = true
		if Dice3 is Sprite:
			Dice3.visible = true
		hitCanBePressed = true
		setDiceSprites()
		print(str(dice_powers))
		$"Hitbox/Hit Shape".disabled = true
	if event.is_action_pressed("roll_dice") and can_move and can_roll:
		var roll_screen = load("res://scene/GUI/RollScreen.tscn").instance()
		pick_power()
		roll_screen.get_node("Roll Screen").set_power(active_power)
		get_parent().add_child(roll_screen)
		can_move = false
	if event.is_action_pressed("attack"):
		# call pick_power, conditional statements for which power to use
		if active_power == 0:
			# basic fireball functionality
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		if active_power == 1:
			var elecball = ELECTRIC_BALL.instance()
			var direction
			if sign($Position2D.position.x) == 1:
				direction = 1
			else:
				direction = -1
			elecball.linear_velocity.x = direction * 900
			elecball.linear_velocity.y = -400
			get_parent().add_child(elecball)
			elecball.position = $Position2D.global_position
		if active_power == 2:
			$"Player Sprite".set_texture(ROCK)
			velocity.y = JUMP_SPEED * 1.5
			yield(get_tree().create_timer(.5), "timeout")
			GRAVITY = 300
			"""yield(get_tree().create_timer(.5), "timeout")
			GRAVITY = 300
			yield(get_tree().create_timer(.5), "timeout")
			GRAVITY = 30
			$"Player Sprite".set_texture(default)
			while on_ground == false:
				_on_Hitbox_body_entered($Hurtbox/Walkbox)"""
			yield(get_tree().create_timer(.5), "timeout")
			GRAVITY = 30
			$"Player Sprite".set_texture(default)
			

# Makes the game less annoying
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJumpButMightNotBeTouchingGround = false
	
func rememberJumpTime():
	yield(get_tree().create_timer(.1), "timeout")
	jumpJustPressed = false

#func _on_Area2D_body_entered(body):
#	if body.has_method("get_power"):
#		print(body.holding_power)
#		if !enemies_has_hit.has(body):
#			print("enter")
#			if last_slot < dice_powers.size():
#				dice_powers[last_slot] = body.get_power()
#				last_slot += 1
#			else:
#				dice_powers.remove(0)
#				dice_powers.append(body.get_power())
#			can_roll = true
#		body.get_node("AnimationPlayer").play("hurt")
#		enemies_has_hit.append(body)

func setDiceSprites():
	if dice_powers.size() > 0 && dice_powers[0] != null:
		if !Dice1 is Sprite:
			Dice1 = Sprite.new()
		Dice1.texture = load("res://assets/img/entity/player/" + str(dice_powers[0]) + "DiceSide1.png")
		add_child(Dice1)
	if dice_powers.size() > 1 && dice_powers[1] != null:
		if !Dice2 is Sprite:
			Dice2 = Sprite.new()
		Dice2.texture = load("res://assets/img/entity/player/" + str(dice_powers[1]) + "DiceSide2.png")
		add_child(Dice2)
	if dice_powers.size() > 2 && dice_powers[2] != null:
		if !Dice3 is Sprite:
			Dice3 = Sprite.new()
		Dice3.texture = load("res://assets/img/entity/player/" + str(dice_powers[2]) + "DiceSide3.png")
		add_child(Dice3)

func pick_power():
	# If array is not null, set active power to a random value
	if dice_powers.size() > 0:
		active_power = dice_powers[randi() % dice_powers.size()]
		print(str(dice_powers[randi() % dice_powers.size()]))

func damage(dam: int):
	hearts -= dam * 1
	emit_signal("life_changed", hearts)
	if hearts < 0:
		get_tree().change_scene("res://scene/Menu Scene/Death_menu/death_menu.tscn")
	modulate = Color(1,1,1,0)
	yield(get_tree().create_timer(.05), "timeout")
	modulate = Color(1,1,1,1)
	yield(get_tree().create_timer(.05), "timeout")
	modulate = Color(1,1,1,0)
	yield(get_tree().create_timer(.05), "timeout")
	modulate = Color(1,1,1,1)

func knockback(enemy):
	if position.x < enemy.position.x:
		velocity.x = -100
	if position.x > enemy.position.x:
		velocity.x = 100

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Enemies"):
		knockback_direction = (global_position - body.global_position).normalized()
		knockback = knockback_direction * knockback_speed
		damage(1)


func _on_Hitbox_body_entered(body):
	on_ground = true
