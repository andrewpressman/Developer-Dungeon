extends Area2D

signal playerEntered
signal playerExited
var player = null

@export var PickupType : int

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")
	SetSprite(PickupType)
	
func SetSprite(Type : int):
	match PickupType:
		1: # armor
			$Sprite2D.texture = load("res://Assets/TempShield.png")
		2: 	# Key
			$Sprite2D.texture = load("res://Assets/TempKey.png")
		
	PickupType = Type

func onPickup(body):
	if body.name == "Player":
		match PickupType:
			1:
				body.ArmorPickup()
			2: 
				body.KeyPickup()
		kill() #TODO: check if player already has key and only remove when player doesnt have key
	
func kill():
	queue_free()
