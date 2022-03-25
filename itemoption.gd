extends Control
var press=false
var slot_selected=[50] setget, slot_selected_get# for both => slot_seleced_set,slot_selected_get# so we can select select value can be any value bigger then inventory size or smaller then 0
onready var button=$selected
onready var group=get_tree().get_nodes_in_group("slot")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func slot_selected_get():
	return slot_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	$gear.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#### when select button is pressed: we can click on the slot and it will change color (666) aka selected slot and we also add to slot_selected list to make sure if we press again it go back to normal color!!! also we can keep track of all slot selected and delected
func _on_TextureRect_focus_entered(number):
	
	#### just using the build in looop! when in focus we save the number slot_selcted!! everytime we save we replace the number! so before replace i change modulate to normal aslong !! we using 50 as intial so it dont change when we inital start
	if press==false:
		if slot_selected.has(50)==false:
			group[slot_selected[0]].set_modulate("ffffff")
		slot_selected[0]=number # last selected number
		group[slot_selected[0]].set_modulate("666666")
	if press==true:
		slot_selected.append(number)
		group[number].set_modulate("666666")
		#print(slot_selected) #just fyi this will contain 50!!! at start or reset!! so our first one can work! so just remove 50 when u call
		if slot_selected.count(number)>=2:
			slot_selected.remove(slot_selected.find(number))
			slot_selected.remove(slot_selected.find(number))
			group[number].set_modulate("ffffff")

func _on_TextureRect_focus_exited():
	pass # Replace with function body.

 #### change color on press(6666) change color on released(fff) for the button and slot and clear selected slot list
func _on_Button_pressed(): 
	if press==true: #release # did it ooposite but its fine
		button.set_modulate("ffffff")
		if slot_selected.has(50):
			slot_selected.remove(slot_selected.find(50))
		for i in slot_selected.size():
			group[slot_selected[i]].set_modulate("ffffff")
		slot_selected.clear()
		slot_selected.append(50) # so we can always have a number to sell!!! from
		press=false
	elif press==false: # pressed
		button.set_modulate("666666")
		
		press=true



func _on_gear2_toggled(button_pressed):
	if button_pressed:
		$gear.visible=true
	elif button_pressed==false:
		$gear.hide()
	pass # Replace with function body.
