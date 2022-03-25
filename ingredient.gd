extends TextureButton
var slotimage=load("res://resource/images/farm/farminven.tres").duplicate()
var emptyslot=load("res://resource/images/slot.tres")
onready var iamountlabel=get_child(0)
onready var inamelabel=get_child(1)
var haveduplicate=0
var slotposition
signal ingredient_focus

func addingredient(iregion,iamount,iname,type,farmslotpos,duplicateitem):
	if type=="recipe":
		slotimage.region=iregion
		texture_normal=slotimage
		inamelabel.text=iname
		iamountlabel.text=iamount
		slotposition=farmslotpos
		haveduplicate=duplicateitem
	elif iregion==Rect2(Vector2.ZERO,Vector2.ZERO): ## forgot why i had this
		texture_normal=emptyslot
		inamelabel.text="Ingrident"
		iamountlabel.text="0"
		slotposition=null
		haveduplicate=0
		
func changeingredientamount(ingamount):
	iamountlabel.text=ingamount
func checkingname():
	return inamelabel.text
func checkduplicate():
	return haveduplicate

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("ingredient_focus",get_parent().get_parent(),"on_ingredient_focus")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the evious frame.
#func _process(delta):
#	pass


func _on_ingredient_pressed():
	texture_normal=emptyslot
	inamelabel.text="Ingrident"
	iamountlabel.text="0"
	###just added not sure if it will effect anything
	haveduplicate=0
	slotposition=null
	emit_signal("ingredient_focus")

	



