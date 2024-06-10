extends CharacterBody2D

#movement speed
@export var BaseSpeed : int = 500
@export var DashSpeed: int = 800

var currSpeed : int
var collision_detected : bool = false
var dash_used : bool
var dash_cooldown : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	dash_used = false
	currSpeed = BaseSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO	
	
	#movement controls
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1	
	
	#normalize velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * currSpeed
	
	#move player
	position += velocity * delta
	
	#abilities
	if Input.is_action_just_pressed("ui_space") && dash_used == false :
		Dash(delta)
	
	CheckCollision(delta)
	
#switch to dash speed and start timer
func Dash(delta):
	dash_used = true
	$Dash.start()
	currSpeed = DashSpeed

#dash cooldown
func ResetDash():
	dash_used = false
	currSpeed = BaseSpeed

#check if player colldies with another object
func CheckCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision_detected = true
		#Trigger action
		#print("Collision detected with: ", collision.get_collider().get_meta("ID"))
	else:
		collision_detected = false

