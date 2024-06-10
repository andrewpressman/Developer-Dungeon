extends RigidBody2D

#multiplier to change the chase/retreat speed
@export var ChaseSpeed : int = 1
@export var FleeSpeed : int = 5

#plyaer
var player : CharacterBody2D

#True: move towards player, false; move away from player
var ChaseMode : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")
	ChaseMode = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		var motion = Vector2.ZERO
		
		if ChaseMode:
			motion += position.direction_to(player.position) * ChaseSpeed
		else:
			motion += position.direction_to(player.position) * FleeSpeed
			motion = -motion
		
		motion = move_and_collide(motion)


func reverseMove():
	ChaseMode = false
	$Timer.start()

func resumeChase():
	ChaseMode = true

func kill():
	queue_free()