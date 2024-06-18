extends Area2D

@export var Level : int

var Hub : Node2D

func _ready():
	Hub = get_parent()

func Teleport():
	Hub.Teleport(Level)
