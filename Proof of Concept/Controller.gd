extends Node2D

var Enemy = preload("res://Proof of Concept/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnerClock.start()
	
func spawn():
	print("spawn")
	var e = Enemy.instantiate()
	e.position = Vector2(0,0)
	add_child(e)
