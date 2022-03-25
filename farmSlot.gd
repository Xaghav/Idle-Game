extends TextureButton
###just fyi make a group of all node and then add image to each node that way since all slot node share the file if we change her then all will get changed at once unless i do get parent getchild(..) and change that way
export (String)var farmitem:String="empty"
export (String)var farmitemtype:String="empty"
var slotimage=load("res://resource/images/farm/farminven.tres").duplicate() # create duplicate so all slot has its own image instance!!
onready var cookslot=get_node("../../../../../../../../inventory/CenterContainer_inv/TabContainer/Cooking/Cooking") #/inventory/CenterContainer_inv/TabContainer/cookemy/cookemy
var a=2
var slotselected setget setslotselected,getb
var c=0
onready var label=$amount
signal focus
func _ready():
	self.connect("focus",get_node("../../"),"on_slot_focus") ### connect signal from all this node/all instances to ../../../
	pass
func setslotselected(slotselect):
	slotselected=slotselect
func getb():
	return slotselected

func amountupdate(amount):
	print("slot now has "+amount +" to existing slot")
	if cookslot!=null:
		cookslot.amountchange(get_position_in_parent(),amount)
func slotupdate(imagepath):
	slotimage.region=imagepath
	texture_normal=slotimage
	if cookslot!=null: # send signal to cooking node which then add to cook slot!!!
		cookslot.additemtoslot(get_position_in_parent(),imagepath,label.text,farmitem,farmitemtype)
#func _gui_input(event):
#	if event is InputEventMouseButton and event.pressed==true and event.button_index != BUTTON_WHEEL_DOWN and event.button_index != BUTTON_WHEEL_UP:
#		inital
#	if event is InputEventMouseButton and event.pressed==false and event.button_index != BUTTON_WHEEL_DOWN and event.button_index != BUTTON_WHEEL_UP:
#		pass
#





func _on_farmslot_focus_entered():
	setslotselected(get_position_in_parent())
	self.set_modulate("666666")
	emit_signal("focus",slotselected,farmitem,farmitemtype,label.text)
	







func _on_farmslot_focus_exited():
	self.set_modulate("ffffff")
	pass # Replace with function body.







