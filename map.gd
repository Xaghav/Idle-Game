extends Control
onready var PrevButton=get_node("Panel/Panel2/HBoxContainer2/Button")
onready var NextButton=get_node("Panel/Panel2/HBoxContainer2/Button5")
onready var levelgroup=get_tree().get_nodes_in_group("levelDisplay")
var increment=5
var currentchapter=1

signal maplevel
func sendmapLevel(level):
	emit_signal("maplevel",level)


##
func _on_checkButton_toggled(button_pressed,numb):
	if button_pressed==true:
		NextButton.text=str(numb)
		PrevButton.text=str(numb)
		increment=numb


func _on_prevButton_pressed():
	if increment>=0:
		increment*=-1
	get_tree().call_group("levelDisplay","display_level_label",increment)

func _on_nextButton_pressed():
	if increment<=0:
		increment*=-1
	get_tree().call_group("levelDisplay","display_level_label",increment)


func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed==true:
		currentchapter=extra_arg_0
		currentchapter=int(levelgroup[currentchapter].level_label.text)
		sendmapLevel(currentchapter)




