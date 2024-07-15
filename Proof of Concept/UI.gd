extends CanvasLayer

@onready var ScoreLabel = $Control/MarginContainer/Score
@onready var ArmorLabel = $Control/MarginContainer/Armor
@onready var KeyLabel = $Control/MarginContainer/Key

func updateScore():
	ScoreLabel.text = "Score: " + str(GlobalVariables.Score)
	
func updateArmor():
	ArmorLabel.text = "\nArmor: " + str(GlobalVariables.CurrHealth - 1)

func updateKey():
	if GlobalVariables.HasKey:
		KeyLabel.text = "\n\nKey: yes"
	else:
		KeyLabel.text = "\n\nKey: no"
