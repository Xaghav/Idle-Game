extends Node2D
var level= 1
onready var map=$Popup
onready var savegroup=get_tree().get_nodes_in_group("savegame")

func _ready():
	pass 


func _on_Button_pressed():
	map.popup()




func _on_savebutton_pressed():
	savegroup[0].saveinventoryinfo()
	savegroup[1].savestatinfo()
	savegroup[2].save_farm()
	savegroup[4].savepinfo()
	savegroup[3].savefarminv()





