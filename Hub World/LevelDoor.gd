extends Area2D

@export var Level : int

var Hub : Node2D
var player = null

func _ready():
	Hub = get_node("/root/Hub")
	player = get_node("/root/Hub/Player")

func Teleport(body):
	if body.name == "Player":
		Hub.Teleport(Level)
