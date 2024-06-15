extends CharacterBody2D

#movement variables(balance feel here) 
@export var BaseSpeed : int = 200
@export var DashSpeed: int = 800

@export var BaseAcceleration : float = 1
@export var Basefriction : float = 1

@export var DashAcceleration : float = 0.2
@export var Dashfriction : float = 0.1

@export var TrapReduction : int = 4

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
	var input = Vector2()
	#movement controls
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1	
	
	return input	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	CheckArmor()
	var direction
	if isInvuln:
		direction = ReverseDirection
		if !dash_used:
			velocity = velocity.lerp(Vector2.ZERO, currFriction)
			Dash(delta, true)
	else:	
		direction = GetInput()
		if direction.length() > 0:
			velocity = velocity.lerp(direction.normalized() * currSpeed, currAccel)
		else:
			velocity = velocity.lerp(Vector2.ZERO, currFriction)
	
	move_and_slide()
	
	#abilities
	if (Input.is_action_just_pressed("ui_space") || Input.is_action_just_pressed("gamepad_a")) && (dash_used == false && dash_available == true):
		Dash(delta, false)
	
	CheckCollision(delta)
	
func CheckArmor():
	if GlobalVariables.CurrHealth > 0:
		$Armor.visible = true
	else:
		$Armor.visible = false	
	
#switch to dash speed and start timer
#type = false : manual dash
#type = true : auto dash
func Dash(delta, type: bool):
	dash_used = true
	$Dash.start()
	currSpeed = DashSpeed
	currAccel = DashAcceleration
	currFriction = Dashfriction
	if type:
		velocity = velocity.lerp(ReverseDirection.normalized() * currSpeed, currAccel)

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
			2:
				ArmorPickup(collision.get_collider())
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

func ArmorPickup(Pickup):
	GlobalVariables.CurrHealth += 1
	Pickup.kill()

func BasicEnemy(enemy : RigidBody2D):
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


