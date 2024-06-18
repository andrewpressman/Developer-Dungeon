extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func goToLevel(level):
	match level:
		1:
			#Go to level 1
			get_tree().change_scene_to_file("res://Proof of Concept/Main.tscn")
