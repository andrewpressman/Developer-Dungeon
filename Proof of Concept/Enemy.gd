extends RigidBody2D

#chase speed
@export var ChaseSpeed : int = 50

#plyaer
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		var Direction = (player.position - position).normalized()
		position += Direction * ChaseSpeed * delta
