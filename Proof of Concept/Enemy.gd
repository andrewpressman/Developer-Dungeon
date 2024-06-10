extends RigidBody2D

#multiplier to change the chase speed
@export var ChaseSpeed : int = 1

#plyaer
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		var motion = Vector2.ZERO
		motion += position.direction_to(player.position) * ChaseSpeed
		motion = move_and_collide(motion)

func kill():
	queue_free()
