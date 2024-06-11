extends CharacterBody2D

#movement speed
@export var BaseSpeed : int = 200
@export var DashSpeed: int = 800

@export var BaseAcceleration : float = 1
@export var Basefriction : float = 1

@export var DashAcceleration : float = 0.2
@export var Dashfriction : float = 0.1

var currSpeed : int
var currAccel : float
var currFriction: float

var collision_detected : bool = false
var dash_used : bool
var dash_cooldown : Timer
var CurrHealth : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	dash_used = false
	currSpeed = BaseSpeed
	currAccel = BaseAcceleration
	currFriction = Basefriction
	

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
func _process(delta):
	CheckArmor()
	var direction = GetInput()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * currSpeed, currAccel)
	else:
		velocity = velocity.lerp(Vector2.ZERO, currFriction)
	move_and_slide()
	
	#abilities
	if (Input.is_action_just_pressed("ui_space") || Input.is_action_just_pressed("gamepad_a")) && dash_used == false :
		Dash(delta)
	
	CheckCollision(delta)
	
func CheckArmor():
	if CurrHealth > 0:
		$Armor.visible = true
	else:
		$Armor.visible = false	
	
#switch to dash speed and start timer
func Dash(delta):
	dash_used = true
	$Dash.start()
	currSpeed = DashSpeed
	currAccel  = DashAcceleration
	currFriction  = Dashfriction

#dash cooldown
func ResetDash():
	$DashCooldown.start()
	currSpeed = BaseSpeed
	currAccel  = BaseAcceleration
	currFriction  = Basefriction

func DashCooldown():
	dash_used = false

#check if player colldies with another object
func CheckCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
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

func ArmorPickup(Pickup):
	CurrHealth += 1
	Pickup.kill()

func BasicEnemy(enemy : RigidBody2D):
	CurrHealth -= 1
	if currSpeed == DashSpeed:
		enemy.kill()
	else:
		enemy.reverseMove()


