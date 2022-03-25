extends ScrollContainer
onready var displayitem=get_node("../Label")
var currentitem
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal focus(farmslot,farmitem,farmitemtype,amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	displayitem.text="Selected Item:"
	pass # Replace with function body.

func _physics_process(_delta):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_slot_focus(farmslot,farmitem,farmitemtype,amount):
	emit_signal("focus",farmslot,farmitem,farmitemtype,amount)
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

