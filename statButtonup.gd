extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button").connect("button_down",self,"_on_Button_button_down",[1])
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button2").connect("button_down",self,"_on_Button_button_down",[10])
	get_node("../../../../Panel/CenterContainer/HBoxContainer/Button3").connect("button_down",self,"_on_Button_button_down",[100])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down(increment):
	text="+"+str(increment)
