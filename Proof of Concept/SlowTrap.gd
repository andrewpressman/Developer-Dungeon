extends Area2D

signal playerEntered
signal playerExited
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")


func onTrapBodyEntered(body):
	if body.name == "Player":
		body.TrapEntered()
		
func onTrapBodyExited(body):
	if body.name == "Player":
		body.TrapExited()
		
