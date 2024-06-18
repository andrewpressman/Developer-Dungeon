extends CharacterBody2D

#movement variables(balance feel here) 
@export var BaseSpeed : int = 300
@export var DashSpeed : int = 1000

@export var BaseAcceleration : int = 1500
@export var Basefriction : int = 2000

@export var DashAcceleration : int = 2000
@export var Dashfriction : int = 0

@export var TrapReduction : int = 4

@onready var direction = Vector2.ZERO

#current values (changed by code)
var currSpeed : int
var currAccel : float
var currFriction: float

#Collision deteced
var collision_detected : bool = false
var ReverseDirection : Vector2 = Vector2.ZERO

#Dash variables
var dash_used : bool
var dash_cooldown : Timer
var dash_available : bool

#invulnerabilty
var isInvuln : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	dash_used = false
	dash_available = true
	currSpeed = BaseSpeed
	currAccel = BaseAcceleration
	currFriction = Basefriction
	isInvuln = false
	
func SetCamera():
	$Camera2D.make_current()

func GetInput():
	#movement controls	
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return direction.normalized()	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	CheckArmor()
	if isInvuln:
		direction = ReverseDirection
		if !dash_used:
			velocity = velocity.lerp(ReverseDirection, 10)
			Dash(delta)
	else:	
		move(delta)
	
	#abilities
	if (Input.is_action_just_pressed("ui_space") || Input.is_action_just_pressed("gamepad_a")) && (dash_used == false && dash_available == true):
		Dash(delta)
	
	CheckCollision(delta)

func move(delta):
	direction = GetInput()
	if direction == Vector2.ZERO:
		applyFriction(currFriction * delta)
	else:
		applyMovement(direction * currAccel * delta)
	move_and_slide()

func applyFriction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
		
	else:
		velocity = Vector2.ZERO
		
func applyMovement(accel):
	velocity += accel
	velocity = velocity.limit_length(currSpeed)
	
func CheckArmor():
	if GlobalVariables.CurrHealth > 0:
		$Armor.visible = true
	else:
		$Armor.visible = false	
	
#switch to dash speed and start timer
#type = false : manual dash
#type = true : auto dash
func Dash(delta):
	dash_used = true
	$Dash.start()
	currSpeed = DashSpeed
	currAccel = DashAcceleration
	currFriction = Dashfriction

#dash cooldown
func ResetDash():
	$DashCooldown.start()
	currSpeed = BaseSpeed
	currAccel  = BaseAcceleration
	currFriction  = Basefriction

func DashCooldown():
	dash_used = false

#check if player colldies with another object/enemy
func CheckCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision && !isInvuln:
		collision_detected = true
		match(collision.get_collider().get_meta("ID")):
			1:
				BasicEnemy(collision.get_collider())
		#Trigger action
		#print("Collision detected with: ", collision.get_collider().get_meta("ID"))
	else:
		collision_detected = false

func TrapEntered():
	dash_available = false
	currSpeed /= TrapReduction
	
func TrapExited():
	dash_available = true
	currSpeed = BaseSpeed

func ArmorPickup():
	GlobalVariables.CurrHealth += 1

func BasicEnemy(enemy : RigidBody2D):
	print("hit")
	if !isInvuln:
		GlobalVariables.CurrHealth -= 1
		if currSpeed == DashSpeed:
			enemy.kill()
		else:
			Reverse(enemy)
			enemy.reverseMove($Player)
			IFrames()

func IFrames():
	isInvuln = true
	dash_available = false
	$Iframes.start()
	
func resetInvuln():
	isInvuln = false
	dash_available = true

func Reverse(enemy : RigidBody2D):
	var direction = (enemy.position - position)
	ReverseDirection = -direction


