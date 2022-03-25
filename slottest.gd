extends TextureRect
var move_slot=false
var Grid_slot_move
var width=3
var height=4
var test=[]
export(Color) var color:Color=Color(0,0.5,0.5,1)
export(Array) var stat :Array
export(String) var item_type:String
var nod_position_in_tree=Vector2.ZERO
var current_pos
var end_pos
onready var shade=preload("res://resource/images/changecolor.tres").duplicate()
onready var group= get_tree().get_nodes_in_group("slot")
onready var scroll=get_node("../..")
onready var label=get_child(0)
var rarity
var scrollvale=0
signal sort_slot
signal switch_texture

func create_array(w,row): #ex (4,0)==>[0,1,2,3],(4,1)=>[4,5,6,7]# starting with 1st row =0 w=lenght of array and row= which row it is 
	var array=[]
	for x in range(w):
		array.append(x+w*row)
	return array
func _ready():
	scroll.get_v_scrollbar().rect_min_size.x=15
	material=shade ## attach shader to slot
	change_color("normal")
	#texture.resource_name="empty"
	Grid_slot_move=[create_array(4,0),create_array(4,1),create_array(4,2),create_array(4,3),create_array(4,4),create_array(4,5)] #create_arry creates a row!!!
	#print(Grid_slot_move)
	
	
	
	
func _physics_process(_delta)->void:
	if has_focus():
		release_focus()
	if move_slot==true:
		rect_global_position=get_global_mouse_position()
		pass


##### instead of doing all this i could just get child position where mouse clicked and mouse relase and switch the child position or just assign the child position where mouse was released (will give the position instead of the array compareson)if the slot is empty!! can check empty by texture.resource_name or use array !!! where position is index number
## duh it wont get input of 2nd while click is active cuz it only get input when that node is in focus
func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed==true : #check mouse button(scroll,presses etc), event is pressed(button down pretty much),# mouse scroll also counts for some reason!!!
		scrollvale=scroll.scroll_vertical ### store current pos ofscroll
		scroll.scroll_vertical_enabled=false
		scroll.rect_position.y=-scrollvale ## move it up since we disabled scroll!!! and panel node has clip off content so now we wont see content at top and !!! now we can switch bottom slots!!!
		current_pos=get_position_in_parent()
		#print(current_pos,"initiallly")
		move_slot=true
		
		#### perfect for scroll no long need to do the array to get position!!!
		##########print("child position", self.get_position_in_parent()) ## could have jsut done this... istead of array
	elif event is InputEventMouseButton and event.pressed==false: # mouse released
		scrollvale=0
		scroll.scroll_vertical_enabled=true
		scroll.rect_size.y=230
		scroll.rect_position.y=-scrollvale
		 ### position where released.. i could jsut do this instead of array thing....
		#print("released")
		#emit_signal("switch_texture",current_pos,end_pos)
		#end_pos=event.position
		
		move_slot=false
		
######ctl+k to access all previous that work!!! we dont need to make the row collmn thing 
		for i in range(4):##column we in # depend on width ea width has its own column
			if rect_position.x>((rect_size.x)*(i)): ## looks to the left so 0,0 looks at-1 techniqually
				nod_position_in_tree.y=i
		for j in range(6): ### row we in !!! gotta think diff for this!! # depend on height
			if rect_position.y>((rect_size.y)*(j)):
				nod_position_in_tree.x=j
		#print("rrrrr",self.texture.resource_name)


		### what we can do is instead of moving the child!!! we chould check the resource name of that child and if its empty then we can switch if not empty then cant switch!!1


#		if rect_position.x<rect_size.x:
#			nod_position_in_tree.x=0
#		elif rect_position.x<(rect_size.x)*2:
#			nod_position_in_tree.x=1
#		elif rect_position.x<rect_size.x*3:
#			nod_position_in_tree.x=2
#		elif rect_position.x<rect_size.x*1000:  # in case its goes outside the x length
#			nod_position_in_tree.x=2

		####### move child position !!!
		#print("position",Grid_slot_move[nod_position_in_tree.x][nod_position_in_tree.y],get_parent().move_child(get_node(get_path()),Grid_slot_move[nod_position_in_tree.x][nod_position_in_tree.y])) ## moving child position
		#get_parent().move_child(get_node(get_path()),2)  #### move slot 
#		if get_parent().get_child(Grid_slot_move[nod_position_in_tree.x][nod_position_in_tree.y]).texture.resource_name=="empty_slot": ## this child
#			get_parent().get_node(get_path()).texture=null # remove texture from self #
#			#get_parent().get_child(Grid_slot_move[nod_position_in_tree.x][nod_position_in_tree.y]).texture= 
		##### or i can just send a signal that gives child position and current node positin as child to parent node to add and remove texture!!!!
		emit_signal("sort_slot") ## send signal to auto update position!! in grid container
		### self position(mouse initally clicked), slot where mouse was released!!!!!)

		emit_signal("switch_texture",current_pos,Grid_slot_move[nod_position_in_tree.x][nod_position_in_tree.y]) ## sending self position in child (should be same position in group) the sending position of slot as child where mouse was released!!! to switch texture 



	### just create array that store x amount of values and send position of the index with item then just add pic to child(aka slot) at that postion

## problem before was when we clicked we couldnt get child position where we stoped click!!! now we can!!!!
####work aswell!!!!!
#func get_drag_data(position): ### at start of drag it will get its texture and index number so later we can switch!! 
#	var data=texture
#	return data
#func can_drop_data(position, data): ### takes the data and send to drop_data!!!! it wont work without this
#	return data
#func drop_data(position, data):  ### at end of click what ever texture it has it will place here or !!! what we could do is get index() and texture of current node where click let go then switch the texture between the two
#
#	texture=data ### this will put the texture from inital click
#	return print("aaaaaa",position)

func amount():
	return int(label.text)
func changeamount(givenamount):
	if givenamount==0:
		label.text=""
	else :
		label.text=String(givenamount)
func change_color(item_rarity):
	if item_rarity=="rare":
		color=Color(0,0.5,0.5,1)
		rarity=item_rarity
		material.set_shader_param("new_color",color)
	elif item_rarity=="normal":
		rarity=item_rarity
		material.set_shader_param("new_color",Color(0,0,0,1))



func _on_accessory_focus_entered():
	print("focccsss")
