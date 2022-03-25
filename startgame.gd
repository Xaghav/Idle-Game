extends Node2D
onready var save_load=load("res://resource/game/save.gd").new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var custominfo=save_load.load_game()
	if custominfo.has("charactercustom"):
		queue_free()
		get_tree().change_scene("res://resource/game/level.tscn")
	else:
		get_tree().change_scene("res://resource/game/characterCustomization.tscn")
		
		###### just example to see if it all works but we dont need to load all this!!!

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
