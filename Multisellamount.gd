extends WindowDialog
onready var label=get_node("Label")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func currentscrollamount():
	return int(label.text)

func _on_HScrollBar_value_changed(value):
	label.text=String(value)
