extends Node2D

var Enemy = preload("res://Proof of Concept/Enemy.tscn")
var Armor = preload("res://Proof of Concept/ArmorPickup.tscn")

var GameActive : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnerClock.start()
	$Player.SetCamera()
	GlobalVariables.CurrHealth = GlobalVariables.BaseHealth
	GameActive = true
	
func _process(delta):
	if GlobalVariables.CurrHealth < 0 && GameActive == true:
		GameActive = false
		$Camera2D.make_current()
		print("dead")
	
	
func spawn():
	print("spawn")
	var e = Enemy.instantiate()
	e.position = Vector2(0,0)
	add_child(e)
	
	var A = Armor.instantiate()
	var X = randi_range(-100,100)
	var Y = randi_range(-200,200)
	A.position = Vector2(X,Y)
	add_child(A)
