extends KinematicBody2D

export var GRAVITY = 30
export var JUMP_SPEED = -900
const WALK_SPEED = 100

var normal_tex = load("res://assets/img/entity/player/playerTEMP.png")
var hit_tex = load("res://assets/img/entity/player/playerTEMPHIT.png")

var velocity = Vector2.ZERO
var canJumpButMightNotBeTouchingGround = true
var jumpJustPressed = false

var dice_powers = []

func _ready():
	pass # Replace with function body.

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
	if event.is_action_pressed("steal_attack"):
		$"Player Sprite".texture = hit_tex
		yield(get_tree().create_timer(1), "timeout")
		$"Player Sprite".texture = normal_tex

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
		body.queue_free()
