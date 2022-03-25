extends Button


func _ready():
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button").connect("button_down",self,"_on_Button_button_down",[1])
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button2").connect("button_down",self,"_on_Button_button_down",[10])
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button3").connect("button_down",self,"_on_Button_button_down",[100])




func _on_Button_button_down(increment):
	text="-"+str(increment)
