extends CanvasLayer

@onready var ScoreLabel = $Control/MarginContainer/Score
@onready var ArmorLabel = $Control/MarginContainer/Armor

func updateScore():
	ScoreLabel.text = "Score: " + str(GlobalVariables.Score)
	
func updateArmor():
	ArmorLabel.text = "\nArmor: " + str(GlobalVariables.CurrHealth - 1)
