extends CharacterBody2D

#movement variables(balance feel here) 
@export var BaseSpeed : int = 300
@export var DashSpeed : int = 3000

@export var BaseAcceleration : int = 1500
@export var Basefriction : int = 300

@export var DashAcceleration : int = 3000
@export var Dashfriction : int = 0

@export var TrapReduction : int = 4

@onready var direction = Vector2.ZERO
@onready var CurrentDirection : Vector2

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
var MoveOverride : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	dash_used = false
	dash_available = true
	currSpeed = BaseSpeed
	currAccel = BaseAcceleration
	currFriction = Basefriction
	isInvuln = false
	$Camera2D/UI.visible = true
	GlobalVariables.Score = 0
	GlobalVariables.CurrHealth = GlobalVariables.BaseHealth
	
	$Camera2D/UI.updateScore()
	$Camera2D/UI.updateArmor()
	
func SetCamera():
	$Camera2D.make_current()

func GetInput():
	#movement controls	
	if !MoveOverride: 
		direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if direction != Vector2.ZERO:
		CurrentDirection = direction
	return direction.normalized()	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	CheckArmor()
	if isInvuln:
		direction = ReverseDirection
		if !dash_used:
			Dash(delta)
	else:	
		move(delta, false)
	
	#abilities
	if (Input.is_action_just_pressed("ui_space") || Input.is_action_just_pressed("gamepad_a")) && (dash_used == false && dash_available == true):
		Dash(delta)
	
	CheckCollision(delta)

#type = true : dash
#type = false: normal move
func move(delta, type):
	if !type:
		direction = GetInput()
	else:
		direction = CurrentDirection
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
func Dash(delta):
	dash_used = true
	MoveOverride = true
	$Dash.start()
	currSpeed = DashSpeed
	currAccel = DashAcceleration
	#currFriction = Dashfriction
	move(delta,true)

#dash cooldown
func ResetDash():
	$DashCooldown.start()
	MoveOverride = false
	currSpeed = BaseSpeed
	currAccel  = BaseAcceleration
	#currFriction  = Basefriction
	velocity = velocity.limit_length(currSpeed)

func DashCooldown():
	dash_used = false

#check if player colldies with another object/enemy
func CheckCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision && !isInvuln:
		collision_detected = true
		if collision.get_collider().has_meta("ID"):
			match(collision.get_collider().get_meta("ID")):
				1:
					BasicEnemy(collision.get_collider())
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
	$Camera2D/UI.updateArmor()

func BasicEnemy(enemy : RigidBody2D):
	if !isInvuln:
		GlobalVariables.CurrHealth -= 1
		if currSpeed == DashSpeed:
			GlobalVariables.Score += 1
			$Camera2D/UI.updateScore()
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


