extends Area2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")

func onEnter(body):
	if body.name == "Player":
		print("player")
		if body.currSpeed == body.DashSpeed:
			kill()

func kill():
	queue_free()
