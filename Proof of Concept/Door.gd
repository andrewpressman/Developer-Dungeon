extends Area2D

@export var DoorType : int
#1: area door?
#2: level door?

var Hub : Node2D
var player = null

func _ready():
	Hub = get_node("/root/Hub")
	player = get_node("/root/Hub/Player")

func Teleport(body):
	pass

func Open():
	pass
	
	
func kill():
	queue_free()
