extends Node2D
onready var tilemap=get_node("ScrollContainer/CenterContainer/TileMap")
onready var time=$Timer
onready var shop=$"ScrollContainer/CenterContainer/SHOP"
var rake=true
var water=true
var seeds=false
enum seedtile{plant1=18,plant2,plant3,plant4,plant5,plant6,plant7} # 5= index of tile aka tell which image to draw on tile for growing
#var seedtile={"plant1":5,"plant2":6,"plant3":7,"plant4":8,"plant5":9,"plant6":10}
var timemultiplyer=2.5
var timeleft={"plant1":3.5*timemultiplyer,"plant2":9.4*timemultiplyer,"plant3":10.8*timemultiplyer,"plant4":12.8*timemultiplyer,"plant5":14.9*timemultiplyer,"plant6":16.1*timemultiplyer,"plant7":19.1*timemultiplyer}# grow time should be less or close:  plant1-1x,2=2.71x,3-3.1x,4-3.7x,5-4.29x,6-4.86,7-5.7x
var unlockspot=[] # position of all unlocks spot so we can draw soil to it!!
var timeLeft=[]
var plantpos=[]
var tiletype=[]
var pickplantpos=[]
var pickplanttiletype=[]
var farminfo=[[],[],[]]
var slotselected # name of the item being selected
var growtime # takes the name and find amount till growth
var slotpos # slot position in the parent
var amountleft :int#keeps track of amount of item left in selected slot
var slotbought=[]
var slotcost=10
onready var save_load=load("res://resource/game/save.gd").new()
onready var tutmessage=get_tree().get_root().get_child(0).get_node("AcceptDialog")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal seedplanted
signal plantgrown
signal plantpickup
signal currentslotselected
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(timeleft)
	### load game when open
	var plantleft=save_load.load_game()
	if plantleft.has("farm_data"):
		plantleft=plantleft.farm_data
		slotcost=plantleft[5]
		slotbought=plantleft[6]
		for i in range(slotbought.size()):
			tilemap.set_cellv(slotbought[i],0)
		for i in range(plantleft[0].size()):
			loadfarmplot(plantleft[0][i],plantleft[1][i],plantleft[2][i])
		for i in range(plantleft[3].size()):
			tilemap.set_cellv(plantleft[4][i],seedtile[plantleft[3][i]])
			pickplantpos.append(plantleft[4][i])
			pickplanttiletype.append(plantleft[3][i])

func loadfarmplot(timetillgrow,pos,type):#if no function then yield will grow one plant each itteration instead of all at their given time#have to make function so we can make create timer as instance for multiple slot and yield each instance!!!
	###it will change the tile to seed and then add grow time and its position
	var slotfinished
	tilemap.set_cellv(tilemap.world_to_map(pos),3)
	var a= get_tree().create_timer(timetillgrow)
	timeLeft.append(a)  ## now when we save we can check the array size and if its bigger we can do for loop and get exact time left for each plant !!!(timeLeft[0].time_left)
	plantpos.append(pos)
	tiletype.append(type)## instead of 3 going to change seed selected and its corresponding tile
	(yield(a,"timeout"))
	for i in range(timeLeft.size()):
				if timeLeft[i].time_left<=0:
					slotfinished=i
					break
	#tilemap.set_cellv(tilemap.world_to_map(pos),seedtile[type])
	tilemap.set_cellv(tilemap.world_to_map(plantpos[slotfinished]),seedtile[tiletype[slotfinished]])
	emit_signal("plantgrown",tiletype[slotfinished],tilemap.world_to_map(plantpos[slotfinished]))
	pickplantpos.append(tilemap.world_to_map(plantpos[slotfinished]))
	pickplanttiletype.append(tiletype[slotfinished])
	timeLeft.remove(slotfinished)
	plantpos.remove(slotfinished)
	tiletype.remove(slotfinished)

		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

## fyi when slot has 0 amount left only updated seed and amountleft var, didnt update slotselected or growtime cuz it dont matter for now to update just do if amount=0:...
func _on_CenterContainer_gui_input(event):
	var slotdone=0
	if event is InputEventMouseButton and event.pressed and event.button_index != BUTTON_WHEEL_DOWN and event.button_index != BUTTON_WHEEL_UP:
		if tilemap.get_cellv(tilemap.world_to_map(event.position))==25 :
			if slotselected=="sand" and slotcost<=amountleft:
				tilemap.set_cellv(tilemap.world_to_map(event.position),0)
				slotbought.append(tilemap.world_to_map(event.position))
				amountleft-=slotcost
				slotcost=int(18*slotbought.size()+pow(3,slotbought.size()*.25))# slotcost= formula for cost where x=slotbought.size()
#				if slotcost>100:
#					slotcost=100
				emit_signal("seedplanted",slotpos,amountleft)
			else:
				tutmessage.dialog_text=("1.Require "+str(slotcost)+" sand to unlock new farming slot \n2.In order to buy, Select the slot with sand\n3.Click on the farming slot with buy now option\n4.Sand is randomly droped by enemy")
				tutmessage.rect_size=tutmessage.rect_min_size
				tutmessage.visible=true
		elif tilemap.get_cellv(tilemap.world_to_map(event.position))==0 and rake==true:#all i haveto do is make sure slot selected is rake # soil tile
			tilemap.set_cellv(tilemap.world_to_map(event.position),1)
		elif tilemap.get_cellv(tilemap.world_to_map(event.position))==1 and water==true:
			tilemap.set_cellv(tilemap.world_to_map(event.position),2)
		elif tilemap.get_cellv(tilemap.world_to_map(event.position))==1 and seeds==true or tilemap.get_cellv(tilemap.world_to_map(event.position))==2  and seeds==true :
			if amountleft==1: ## this mean amount=0 now hence we cant plant from it no more also amount will become 0 on next line!!!!
				seeds=false 
			amountleft-=1
			
			emit_signal("seedplanted",slotpos,amountleft) # connect signal to shop since it has group node already to update inventory
	
			## just have to make specific if watered (2) less time if not water then more time(1)
			#### can juse use loadplant func here aswelll!!!
			tilemap.set_cellv(tilemap.world_to_map(event.position),3)
			var a =get_tree().create_timer(growtime) ###every time we click this var become instance hence why we able to do multiple at once so for auto we have to make a function and call the func and func will make instance for each call/itteration
			timeLeft.append(a)  ## now when we save we can check the array size and if its bigger we can do for loop and get exact time left for each plant !!!(timeLeft[0].time_left)
			plantpos.append(event.position)
			tiletype.append(slotselected)## instead of 7 going to change depended on the seed(fyi 3 is seed tile so that stays just change end result tile) selected and its corresponding tile
			(yield(a,"timeout"))
			for i in range(timeLeft.size()):
				if timeLeft[i].time_left<=0:
					#print("worked",i)
					slotdone=i
					break
			tilemap.set_cellv(tilemap.world_to_map(plantpos[slotdone]),seedtile[tiletype[slotdone]])
			emit_signal("plantgrown",tiletype[slotdone],tilemap.world_to_map(plantpos[slotdone]))
			pickplantpos.append(tilemap.world_to_map(plantpos[slotdone]))
			pickplanttiletype.append(tiletype[slotdone])
			timeLeft.remove(slotdone)
			plantpos.remove(slotdone)
			tiletype.remove(slotdone)
			
		elif tilemap.get_cellv(tilemap.world_to_map(event.position))>=18 : # and tilemap.get_cellv(tilemap.world_to_map(event.position))>=5 and tilemap.get_cellv(tilemap.world_to_map(event.position))<=10 :
			### item pick up!!!! just need to emit signal
			# starting with tile index 18 not using the one from 5 to 10
			emit_signal("plantpickup",tilemap.get_cellv(tilemap.world_to_map(event.position)),tilemap.world_to_map(event.position))

func _on_Timer_timeout():
	#print("done")
#	tilemap.set_cellv(tilemap.world_to_map(event.position),7)
	pass # Replace with function body.

###shop button aka click anywhere on shop
func _on_Button_pressed():
	shop.popup()
	pass # Replace with function body.
func save_farm():
	farminfo.clear() #saving in same session unless var here so ever time it run its new instance var # so we can update from previous time(aka clear as plant grow time left will be 0 and we wont need their location without this it will keep the last data and append
	farminfo=[[],[],[],[],[],[],[]] # timeleft,plantpos,plant type, also check if any watered and stuff
	farminfo[5]=slotcost
	farminfo[6]=slotbought
	for i in range(timeLeft.size()):
		farminfo[0]+=[timeLeft[i].time_left] # only work when we adding array
	farminfo[1]=plantpos
	farminfo[2]=tiletype
	farminfo[3]=pickplanttiletype
	farminfo[4]=pickplantpos
	save_load.save_game("farm_data",farminfo)


func _on_save_pressed():## no longer there!! took it off
	###array test
#	var a=[[10,11],[12,13]]
#	a[0][1]=15 # able to change the value but not add more value 
#	a[0]+=[11] # to add more value we can use append or +=[value]  # has to be inside array
#	a[0].append(11) ## or can do this to add value
#	print(a) 


	###save time left and position of the plant and type of plant / soil!!!!!
#### moved it all to save function!!!!
#	farminfo.clear() ## so we can update from previous time as plant grow time left will be 0 and we wont need their location without this it will keep the last data and append
#	farminfo=[[],[],[]] # timeleft,plantpos,plant type, also check if any watered and stuff
#	for i in range(timeLeft.size()):
#		farminfo[0]+=[timeLeft[i].time_left] # only work when we adding array
#	farminfo[1]=plantpos
#	farminfo[2]=tiletype
	save_farm()
	#print(farminfo) ## to pull we jsut do farminfo[0][1]  this give row 1 collum 2
	pass # Replace with function body.


func _on_focus(farmslot,farmitem,farmitemtype,amount): ## has to figure a way to update when empty and stuff
	slotpos=farmslot
	print(farmitem)
	#print(farmslot,farmitem,amount)
	if farmitem!="empty" and farmitemtype!="tool" and farmitemtype!="recipe":
		seeds=true # dont forget to change to fall when have 0 left!!!
		slotselected=farmitem
		growtime=timeleft[farmitem]
		amountleft=int(amount)
	elif  farmitem=="sand":
		print("aaaa")
		seeds=false
		slotselected=farmitem
		amountleft=int(amount)
	elif farmitem=="empty" or farmitem=="tool" or farmitemtype=="recipe" :
		seeds=false
		amountleft=0
#	print([farmslot,farmitem,amount])
	emit_signal("currentslotselected",farmslot)


func _on_SHOP_itempicked(picked,farmslotpos):
	if picked:
		tilemap.set_cellv(farmslotpos,0)
		pickplanttiletype.remove(pickplantpos.find(farmslotpos))
		pickplantpos.remove(pickplantpos.find(farmslotpos))
	pass # Replace with function body.
func _on_farm_tutcontinue():
	tutmessage.dialog_text="1.Click on Tool Shack to buy seed\n2.To plant seed\n3.Click on soil to rake\n4.Select the seed inside invetory\n5.Then click on raked soil to plant\n6.Seed will grow over time\n7 once ready to harvest\nsimple click on that soil with plant "
	tutmessage.rect_size=tutmessage.rect_min_size
	

