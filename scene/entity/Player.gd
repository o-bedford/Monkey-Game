extends KinematicBody2D

export var GRAVITY = 30
export var JUMP_SPEED = -900
const WALK_SPEED = 100

var normal_tex = load("res://assets/img/entity/player/playerTEMP.png")
var hit_tex = load("res://assets/img/entity/player/playerTEMPHIT.png")

var velocity = Vector2.ZERO
var canJumpButMightNotBeTouchingGround = true
var jumpJustPressed = false
var hitCanBePressed = true

var dice_powers = []
var Dice1
var Dice2
var Dice3

func _ready():
	$"Hitbox/Hit Shape".disabled = true

func _process(delta):
	if dice_powers.size() > 6:
		dice_powers.remove(0);

func _physics_process(delta):
	
	# Movement code
	if is_on_floor():
		canJumpButMightNotBeTouchingGround = true
		if jumpJustPressed:
			velocity.y = JUMP_SPEED
	
	if !is_on_floor():
		coyoteTime()
		velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("ui_up"):
		jumpJustPressed = true;
		rememberJumpTime()
		if canJumpButMightNotBeTouchingGround:
			velocity.y = JUMP_SPEED
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= WALK_SPEED
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += WALK_SPEED
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.2)

func _input(event):
	# If the player is able to cube smash, do it. Hide dice face sprites, apply hit texture, wait a bit, and reset
	if event.is_action_pressed("steal_attack") and hitCanBePressed:
		$"Hitbox/Hit Shape".disabled = false
		hitCanBePressed = false
		if Dice1 is Sprite:
			Dice1.visible = false
		if Dice2 is Sprite:
			Dice2.visible = false
		if Dice3 is Sprite:
			Dice3.visible = false
		$"Player Sprite".texture = hit_tex
		yield(get_tree().create_timer(0.7), "timeout")
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

# Makes the game less annoying
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJumpButMightNotBeTouchingGround = false
	
func rememberJumpTime():
	yield(get_tree().create_timer(.1), "timeout")
	jumpJustPressed = false

func _on_Area2D_body_entered(body):
	if body.has_method("get_power"):
		print(body.get_power())
		dice_powers.append(body.get_power())
		body.squash()

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
	
