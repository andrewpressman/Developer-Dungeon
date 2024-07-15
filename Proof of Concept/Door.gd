extends Area2D

@export var DoorType : int
#1: area door?
#2: level door?

func _ready():
	pass

func onEnter(body):
	if body.name == "Player":
		if GlobalVariables.HasKey == true:
			body.ClearKey()
			match DoorType:
				1:
					Open()
				2:
					Teleport()


func Teleport():
	get_tree().change_scene_to_file("res://Hub World/Hub.tscn")

func Open():
	#door open
	kill()
	
	
func kill():
	queue_free()
