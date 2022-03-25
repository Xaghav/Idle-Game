extends Panel
export(String) var defaultLevel
onready var level_label=get_node("VBoxContainer/CenterContainer2/Label")
func _ready():
	pass # Replace with function body.
func display_level_label(increment):
	var display_level=int(level_label.text)+increment
	if display_level>0 and display_level<=1000: 
		level_label.text=str(display_level)
	elif display_level<=0 and level_label.text !=defaultLevel: ## 
		level_label.text=defaultLevel
#		for i in range(5): #1-4 # problem was it would run even when level was 1-5 which is waste so better to just use default!!
#			if display_level==i*-1:
#				level_label.text=str(5-i)
	elif display_level>1000 :
		level_label.text=str(int(defaultLevel)+995) # take 1000-highest numb lvl ex 1000-20=980
