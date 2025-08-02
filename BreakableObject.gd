extends Area2D

var player = null
@export var RequiresKey : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	#player = get_node("/root/Node2D/Player")
	pass

func onEnter(body):
	if body.name == "Player":
		if RequiresKey:
			if GlobalVariables.HasKey:
				body.ClearKey()
				kill()
		else:
			if body.currSpeed == body.DashSpeed:
				kill()

func kill():
	queue_free()
