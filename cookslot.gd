extends TextureButton
###just fyi make a group of all node and then add image to each node that way since all slot node share the file if we change her then all will get changed at once unless i do get parent getchild(..) and change that way
export (String)var farmitem:String="empty"
export (String)var farmitemtype:String="empty"
var slotimage=load("res://resource/images/farm/farminven.tres").duplicate() # create duplicate so all slot has its own image instance!!
var a=2
var slotselected setget setslotselected,getb
var c=0
onready var label=$amount
onready var emptyslot=load("res://resource/images/slot.tres")
onready var displayitem=get_node("../../../selecteditem")
var currentitem="Empty"
signal focus
signal ingridentupdate
func _ready():
	self.connect("focus",get_node("../../../"),"on_cookslot_focus")
	self.connect("ingridentupdate",get_node("../../../"),"on_cookslot_ingridentupdate")
	pass
func setslotselected(slotselect):
	slotselected=slotselect
func getb():
	return slotselected
func test():
	print("test complete")
func camountupdate(amount):
	label.text=amount
	if int(amount)==0:
		farmitem="empty"
		farmitemtype="empty"
		texture_normal=emptyslot
func returncamount():
	return label.text
func cslotupdate(imagepath,amounts,iname,itype):
	
	slotimage.region=imagepath
	texture_normal=slotimage
	label.text=amounts
	farmitem=iname
	farmitemtype=itype
#func _gui_input(event):
#	if event is InputEventMouseButton and event.pressed==true and event.button_index != BUTTON_WHEEL_DOWN and event.button_index != BUTTON_WHEEL_UP:
#		inital
#	if event is InputEventMouseButton and event.pressed==false and event.button_index != BUTTON_WHEEL_DOWN and event.button_index != BUTTON_WHEEL_UP:
#		pass
#





func _on_farmslot_focus_entered():
	setslotselected(get_position_in_parent())
	self.set_modulate("666666")
	emit_signal("focus",slotimage.region,label.text,farmitem,farmitemtype,get_position_in_parent())
	release_focus()

	match farmitem:
		"plant1":
			currentitem="Carrot Seed"
		"plant2":
			currentitem="Herb Seed"
		"plant3":
			currentitem="Corn Seed"
		"plant4":
			currentitem="Radish Seed"
		"plant5":
			currentitem="Sugarcane Seed"
		"plant6":
			currentitem="Mushroom Seed"
		"plant7":
			currentitem="Wheat Seed"
		_:
			currentitem=farmitem
	displayitem.text="Selected Item: "+currentitem.capitalize()







func _on_farmslot_focus_exited():
	self.set_modulate("ffffff")
	pass # Replace with function body.







