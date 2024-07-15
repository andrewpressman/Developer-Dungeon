extends Node2D

var Enemy = preload("res://Proof of Concept/Enemy.tscn")
var Armor = preload("res://Proof of Concept/Pickup.tscn")

var GameActive : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.SetCamera()
	GlobalVariables.CurrHealth = GlobalVariables.BaseHealth
	GlobalVariables.HasKey = false
	GameActive = true
	
func _process(delta):
	if GlobalVariables.CurrHealth < 0 && GameActive == true:
		GameActive = false
		$Camera2D.make_current()
		print("dead")
	
func spawn(body):
	if body.name == "Player":
		var e1 = Enemy.instantiate()
		e1.position = Vector2(1212,-3868)
		add_child(e1)
		var e2 = Enemy.instantiate()
		e2.position = Vector2(1175,-2362)
		add_child(e2)
		var e3 = Enemy.instantiate()
		e3.position = Vector2(-1202,-3866)
		add_child(e3)
		var e4 = Enemy.instantiate()
		e4.position = Vector2(-1197,-2344)
		add_child(e4)
	
#spawn armor
#	var A = Armor.instantiate()
#	var X = randi_range(-100,100)
#	var Y = randi_range(-200,200)
#	A.position = Vector2(X,Y)
#	add_child(A)
