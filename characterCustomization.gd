extends Node2D
var info={"face":0,"mouth":22,"eye":25,"body":1}
var face = info.face
var mouth=info.mouth
var eye=info.eye
var body=info.body
onready var save_load=load("res://resource/game/save.gd").new()
onready var animation=get_node("AnimationPlayer")
onready var bodytype1= get_node("AnimationPlayer").get_animation("bodytype1")
onready var bodytype2= get_node("AnimationPlayer").get_animation("bodytype2")
onready var bodytype3= get_node("AnimationPlayer").get_animation("bodytype3")
onready var bodytype4= get_node("AnimationPlayer").get_animation("bodytype4")
onready var facetexture=get_node("face")
onready var eyetexture=get_node("eye")
onready var mouthtexture=get_node("mouth")
#
func createanimation(bodytype):
	## face already setup in animation player
	#### we could have just set it up in animation and just change spirte frame and that face would have done the animation....
	### eye could just do it in the animation player and the change spirte frame!!!!as thats the image being used to move up down
	bodytype.add_track(0,2) # first one is 0
	bodytype.track_set_path(2,"../eye:position:y") ### to get fram ../eye:frame
	bodytype.value_track_set_update_mode(2,1)#pretty much updates the type of animation continous (ex for position type value will update slowly with increment from frame 1 to frame 2),discrete ( position will stay same and update at end of frame ex position at frame one will be 0 and at frame 2 will be -1 )etc!! track/track position in animation, update mode (1=update at frame and old vaue)
	bodytype.track_insert_key(2,0,0) #track position, at which time, set key type var for this ex its gona be position
	bodytype.track_insert_key(2,0.25,-1) ## because we said y so last one will set up the position some reason -1 dont work but -1.0 works
	bodytype.track_insert_key(2,0.5,0)
	#####MOUTH
	bodytype.add_track(0,3)
	bodytype.track_set_path(3,"../mouth:position:y") 
	bodytype.value_track_set_update_mode(3,1)
	bodytype.track_insert_key(3,0,0) 
	bodytype.track_insert_key(3,0.25,-1)
	bodytype.track_insert_key(3,0.5,0)
	
func _ready():
	createanimation(bodytype1) # add eye and mouth animation to body type 1
	createanimation(bodytype2)
	createanimation(bodytype3)
	createanimation(bodytype4)
	# load the data then update the var then update all animation aswell
	var custominfo=save_load.load_game()
	if custominfo.has("charactercustom"):
		###### just example to see if it all works but we dont need to load all this!!!
		info=custominfo.charactercustom # or custominfo[charactercustom]
		face=info.face
		mouth=info.mouth
		eye=info.eye
		body=info.body
		get_child(0).frame=face
		get_child(1).frame=mouth
		get_child(2).frame=eye
		if body==1:
			animation.current_animation="bodytype1"  ## head eye are part of this animtion so only hae to play with body!!
		if body==2:
			animation.current_animation="bodytype2"
		if body==3:
			animation.play("bodytype3") ## eithertech works
		if body==4:
			animation.play("bodytype4")
		if body>=4:
			body=0
#	###########
	
	
func _on_Button_pressed(button_name):
	
	
	### no animation and just 4 body images 
#var face = 0  # at top of script
#var mouth=22
#var eye=25
#var body=0
#	get_child(5).visible=true
#	get_child(6).visible=true
#	get_child(7).visible=true
#	get_child(8).visible=false
	match button_name:
		"button_face":
			face+=1
			get_child(0).frame=face
			#get_child(5).frame=face  #preview
			if face>20:
				face=0
		"button_mouth":
			mouth+=1
			get_child(1).frame=mouth
			#get_child(7).frame=mouth #preview
			if mouth>23:
				mouth=22
		"button_eye":
			eye+=1
			get_child(2).frame=eye
			#get_child(6).frame=eye#preview
			if eye>27:
				eye=25
		"body":
			
			#get_child(3).frame=body
#			get_child(8).frame=body
#			get_child(5).visible=false
#			get_child(6).visible=false
#			get_child(7).visible=false
#			get_child(8).visible=true

			body+=1   
			print(body)  
			if body==1:
				animation.current_animation="bodytype1"  ## head eye are part of this animtion so only hae to play with body!!
			if body==2:
				animation.current_animation="bodytype2"
			if body==3:
				animation.play("bodytype3") ## eithertech works
			if body==4:
				animation.play("bodytype4")
			if body>=4:
				body=0
	info={"face":face,"mouth":mouth,"eye":eye,"body":body}
#	if button_name=="button_face":
#		get_child(0).frame=face
#		get_child(5).frame=face  #preview
#		face+=1
#		if face>21:
#			face=0
#	if button_name=="button_mouth":
#		get_child(1).frame=mouth
#		get_child(7).frame=mouth #preview
#		mouth+=1
#		if mouth>24:
#			mouth=22
#	if button_name=="button_eye":
#		get_child(2).frame=eye
#		get_child(6).frame=eye#preview
#		eye+=1
#		if eye>28:
#			eye=25
#	if button_name=="body":
#		get_child(3).frame=body
#		body+=1
#		if body>4:
#			body=0
	pass


func _on_done_pressed():
	save_load.save_game("charactercustom",info)
	save_load.load_game()

	queue_free()
	get_tree().change_scene("res://resource/game/level.tscn")
	
