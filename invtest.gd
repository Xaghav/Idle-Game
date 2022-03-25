extends Node2D

# also update gold!!
## switch item,compare item,equp item, add item to inventory and item upgrade
## update weapon to lh,rh,2h, add shield,armor,leg ,accesory (shield,2h,weapon aka rh works fine on equip+ also added where it show inital stat
var count=0
var state
onready var empty_texture=load("res://resource/images/slot.tres")
onready var group= get_tree().get_nodes_in_group("slot")
onready var equipment=get_tree().get_nodes_in_group("equipment")
onready var selected_item=get_node("Control")
onready var item_stat_display=get_node("Control/item")
onready var equip_stat= get_node("Control/equipItem")
onready var gold=get_node("../../../../../Panel/Label") # this is on main lvl scene
onready var metal=get_node("../../../../../Panel/Sprite2/Label")
onready var sellmultiamount=get_node("Multisellamount")
var currentgold=0
var selected_slot=[50] # selected_item.slot_selected_get() to update to correct value
var statss =[] #### didnt update on switch or equipment!!!
#onready var weapon_texture=load("res://resource/images/weapon/weapon.png")  ## huge atlast seprite sheet  to pick reagion to load var weapon_texture.set_region(Rect2(0,0,70,70)) or weapon_texture.region=(Rect2(0,0,70,70)) ==>(x,y,width,height)
onready var save_load=load("res://resource/game/save.gd").new()


var item={"nam":{
	"spec":{"item type":"weapon2h" , "path": "res://resource/images/weapon/0.png"},
	"spec1":{"item type":"weapon2h" , "path": "res://resource/images/weapon/1.png"},
	"spec2":{"item type":"weapon2h" , "path": "res://resource/images/weapon/2.png"},
	"spec4":{"item type":"weapon2h" , "path": "res://resource/images/weapon/3.png"},
	"spec3":{"item type":"weapon2h" , "path": "res://resource/images/weapon/4.png"},
	"axe4":{"item type":"axe" , "path": "res://resource/images/weapon/5.png"},
	"axe2":{"item type":"axe" , "path": "res://resource/images/weapon/6.png"},
	"axe3":{"item type":"axe" , "path": "res://resource/images/weapon/7.png"},
	"axe1":{"item type":"axe" , "path": "res://resource/images/weapon/8.png"},
	"axe":{"item type":"axe" , "path": "res://resource/images/weapon/9.png"},
	"staff":{"item type":"staff" , "path": "res://resource/images/weapon/10.png"},
	"staff3":{"item type":"staff" , "path": "res://resource/images/weapon/11.png"},
	"staff2":{"item type":"staff" , "path": "res://resource/images/weapon/12.png"},
	"staff1":{"item type":"staff" , "path": "res://resource/images/weapon/13.png"},
	"staff4":{"item type":"staff" , "path": "res://resource/images/weapon/14.png"},
	"sword4":{"item type":"sword" , "path": "res://resource/images/weapon/15.png"},
	"sword3":{"item type":"sword" , "path": "res://resource/images/weapon/16.png"},
	"sword1":{"item type":"sword" , "path": "res://resource/images/weapon/17.png"},
	"sword2":{"item type":"sword" , "path": "res://resource/images/weapon/18.png"},
	"sword":{"item type":"sword" , "path": "res://resource/images/weapon/19.png"},
	"helm":{"item type":"helm" , "path": "res://resource/images/weapon/20.png"},
	"armor":{"item type":"armor" , "path": "res://resource/images/weapon/21.png"},
	"leg":{"item type":"leg" , "path": "res://resource/images/weapon/22.png"},
	"shoe":{"item type":"shoe" , "path": "res://resource/images/weapon/23.png"},
	"helm1":{"item type":"helm" , "path": "res://resource/images/weapon/24.png"},
	"armor1":{"item type":"armor" , "path": "res://resource/images/weapon/25.png"},
	"leg1":{"item type":"leg" , "path": "res://resource/images/weapon/26.png"},
	"shoe1":{"item type":"shoe" , "path": "res://resource/images/weapon/27.png"},
	"helm2":{"item type":"helm" , "path": "res://resource/images/weapon/28.png"},
	"armor2":{"item type":"armor" , "path": "res://resource/images/weapon/29.png"},
	"leg2":{"item type":"leg" , "path": "res://resource/images/weapon/30.png"},
	"shoe2":{"item type":"shoe" , "path": "res://resource/images/weapon/31.png"},
	"helm3":{"item type":"helm" , "path": "res://resource/images/weapon/32.png"},
	"armor3":{"item type":"armor" , "path": "res://resource/images/weapon/33.png"},
	"leg3":{"item type":"leg" , "path": "res://resource/images/weapon/34.png"},
	"shoe3":{"item type":"shoe" , "path": "res://resource/images/weapon/35.png"},
	"helm4":{"item type":"helm" , "path": "res://resource/images/weapon/36.png"},
	"armor4":{"item type":"armor" , "path": "res://resource/images/weapon/37.png"},
	"leg4":{"item type":"leg" , "path": "res://resource/images/weapon/38.png"},
	"shoe4":{"item type":"shoe" , "path": "res://resource/images/weapon/39.png"},
	"helm5":{"item type":"helm" , "path": "res://resource/images/weapon/40.png"},
	"helm6":{"item type":"helm" , "path": "res://resource/images/weapon/41.png"},
	"armor5":{"item type":"armor" , "path": "res://resource/images/weapon/42.png"},
	"leg5":{"item type":"leg" , "path": "res://resource/images/weapon/43.png"},
	"shoe5":{"item type":"shoe" , "path": "res://resource/images/weapon/44.png"},
	"helm7":{"item type":"helm" , "path": "res://resource/images/weapon/46.png"},
	"helm8":{"item type":"helm" , "path": "res://resource/images/weapon/47.png"},
	"mushroom soup":{"item type":"food" , "path": "res://resource/images/weapon/food1.png"},
	"cake":{"item type":"food" , "path":"res://resource/images/weapon/food2.png" },
	"health potion":{"item type":"food" , "path":"res://resource/images/weapon/food3.png" },
	"carrot soup":{"item type":"food" , "path":"res://resource/images/weapon/food4.png" },
	"ice cream":{"item type":"food" , "path": "res://resource/images/weapon/food5.png"},
	"pizza":{"item type":"food" , "path":"res://resource/images/weapon/food6.png" },
	"Carrot":{"item type":"food" , "path":"res://resource/images/weapon/food7.png" },
	}}
	####################################tut
var tut=1 #1#equip_gear,2#sell 3#combat basic,4#next level,5#upgrade
var canalert=true
var tabdisable=true
onready var tutmessage=get_tree().get_root().get_child(0).get_node("AcceptDialog")
########################
signal stat_to_player

func _ready():
	loadinventoryinfo()
	tutmessage.get_close_button().visible=false
	tutmessage.visible=true
	tutmessage.get_ok().visible=false
	tutmessage.rect_size=tutmessage.rect_min_size
	if tabdisable==true:
		var tab=get_parent().get_parent()
		#print(tab)
		if tut<=6:# disable stat upgrade, farming, cooking tab/skill
			tab.set_tab_disabled(1,true)
		if tut<=7:
			tab.set_tab_disabled(2,true)
#		tab.set_tab_disabled(3,true)
		if tut==5:#once we finish partsix !! update wont do it so we have to manually do this
			tab.set_tab_disabled(1,false)
	if tut>2:#have to add and tut<max tutnumber so it dont run oncetutorial isover #if the game closed!!! after compeleting part 1 and 2. we need to update the next part
		tutmessage.get_ok().visible=true
		sellmultiamount.popup()
		yield(get_tree(),"idle_frame")
		sellmultiamount.hide()
	#print(Item_type(["buff","craftable"])) ## used [] so can call multiply state with one input or could just use in ready function and not worry about calling it as function
#	state="healing"  #now below it will check if state is healing
#	match state:
#		"healing":
#			print("item for heal")
#		"crafting":
#			print("item for crafting")
func _draw():
	if tut==1:
		draw_circle(Vector2(35,35),50,Color(1,1,1,1))
		draw_circle(Vector2(134,-60),30,Color(1,1,1,1))
		draw_rect(Rect2(-30,-112,70,70),Color(0,0,0,1))
		tutmessage.dialog_text="1.Select the weapon in the slot \n2.selected item stat will be displayed \nabove the inventory Tab \n2.Once item is selected click equip \nto wear ad continue tutorial"
	elif tut==2:
		draw_circle(Vector2(120,-95),20,Color(1,0,0,1))
		draw_circle(Vector2(15,-205),30,Color(1,0,0,1))
		draw_circle(Vector2(35,35),50,Color(1,1,1,1))
		draw_circle(Vector2(296,-62),25,Color(1,1,1,1))
		tutmessage.rect_position=Vector2(35,494)
		tutmessage.dialog_text="Unequip the gear and sell it to proceed!! \n1.click on gear(to view current equip gear) \n2.click on the item to unequip \n3.Select the slot with the weapon \n4.click on sell and then confirm to sell it"
	elif tut==3:
		yield(sellmultiamount,"popup_hide")
		tutmessage.dialog_text="                    Combat Guide\n1.Your player will auto battle the enemy\n2.Every few second, you could also do click damage \nby clicking the attack button left of player\n3.Attack Button is enabled once your player start \ndamaging enemy\n4.Press Ok to continue"
		tutmessage.rect_position=Vector2(5,79)
		tutmessage.rect_size=tutmessage.rect_min_size
		yield(tutmessage,"confirmed")
		tut=4
		update()
	elif tut==4: # dont need to save partfour!!!! cuz it get trigger auto when we update
		tutmessage.visible=true
		tutmessage.dialog_text="              Fight fight\n1.Kill few enemy and once you are ready\n2.Click Select Map to go to next Chaper.\n3.Monster get tougher as Chapter get bigger\n4.Monster on higher Chapter will drop\n better loot and higher Gold"
		tutmessage.rect_size=tutmessage.rect_min_size
		draw_rect(Rect2(-35,-410,100,30),Color(.5,1,1,.5))
		yield(tutmessage,"confirmed")
		tut=5
		update()
	elif tut==5:
		tutmessage.visible=true
		get_parent().get_parent().set_tab_disabled(1,false)
		tutmessage.dialog_text="           Upgrade stats\n1.As your player gain exp and level, \n You can upgrade its stat\n2.Once you are ready\n3.Click on Upgrade tab to upgrade \nplayer stats and other skills"
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(60,79)
		draw_circle(Vector2(130,-30),40,Color(1,1,1,.5))
		#### ontime signal from upgrade tab to upgrade node
		#print(get_parent().get_parent().get_child(1).name,get_parent().get_parent().get_child(1).get_child(0).name)
		get_parent().get_parent().get_child(1).connect("visibility_changed",get_parent().get_parent().get_child(1).get_child(0), "_on_tutcontinue",[],4)
		yield(get_parent().get_parent().get_child(1),"visibility_changed")# will be pressed on upgrade page!!
		tut=6
	elif tut==6:
		get_parent().get_parent().set_tab_disabled(1,false)
		draw_circle(Vector2(130,-30),40,Color(1,1,1,.5))
		tutmessage.visible=false
	elif tut==7:
		tutmessage.visible=true
		tutmessage.dialog_text="           Start Farming\n1.Once ready,Click on farming \ntab to start farming"
		tutmessage.get_ok().visible=true
		tutmessage.rect_size=tutmessage.rect_min_size
		get_parent().get_parent().set_tab_disabled(2,false)
		draw_circle(Vector2(198,-32),33,Color(1,1,1,.5))
		if get_parent().get_parent().get_child(2).is_connected("visibility_changed",get_parent().get_parent().get_child(2).get_child(0), "_on_farm_tutcontinue")==false:
			get_parent().get_parent().get_child(2).connect("visibility_changed",get_parent().get_parent().get_child(2).get_child(0), "_on_farm_tutcontinue",[],4)
		yield(get_parent().get_parent().get_child(2),"visibility_changed")
		tut=8
		pass
		### continue farming tut
#### tut signal from stat update (stat tut done)
func _on_tutdone():
	if tut==6: # in case we get multiple connection cuz of draw func....
		tut=7
		update()
func _on_createdrop_inventory_update(item_name,stats,rareness):  ### we could do get child of grid container and add pic that way or update node positin in group node!! after we move the slot/ pic!!!
	#print(stats,"testing",rareness)
	####add item to inventory

	#print (group[0].texture.resource_name)
	#print(item_name,stat)
	if item_name!="gold" and item_name!="metal" and item.nam.get(item_name).get("item type")!="recipe":# could been else statement but meh
		for i in range(group.size()):
			if group[i].texture.resource_name=="empty_slot":
				additem(i,stats,load(item.nam.get(item_name).get("path")),item.nam.get(item_name).get("item type"),rareness)
				statss.append(stats)
				#group[i].change_color("rare")
				#print(statss[0])
				
				#group[i].texture=load(item.nam.get(item_name).get("path")) #weapon_texture  #### before i saved the path now i preloaded it!!! load(item.nam.get(item_name).get("path")) # check if node is null then grabs path from dictionary based on path
				######print(range(group.size()))
				break # break when first empty slot found!!
	elif item_name=="gold":
		currentgold=int(gold.text)+round(stats[0]) #fyi this value wont be update when i upgrade skill but will be update when enemy drop gold just future ref### this isnt theacutal value i will use the text label text value to update skill and inc decc there!!! so dont use this!!
		gold.text=String(currentgold)
	elif item_name=="metal":
		metal.text=String(int(metal.text)+round(stats[0]))
	elif item.nam.get(item_name).get("item type")=="recipe":
		pass# emit signal/ add the item to farming slot
#ctrl+k to comment/uncomment  all selected line

func addfood(foodamount,foodname,foodstat):
	var foodamountleft=foodamount
	for i in range(group.size()):
		if group[i].texture.resource_path==item.nam.get(foodname).get("path"):
			if group[i].amount()+foodamountleft<=100:
				group[i].changeamount(group[i].amount()+foodamountleft)
				return true
			else:
				foodamountleft=foodamountleft+group[i].amount()-100
				group[i].changeamount(100)
			
	for i in range(group.size()):
		if group[i].texture.resource_name=="empty_slot":
			additem(i,foodstat,load(item.nam.get(foodname).get("path")),item.nam.get(foodname).get("item type"),"normal")
			group[i].changeamount(group[i].amount()+foodamountleft)
			return true
		elif i==group.size()-1:
			return false

#func _ready():
#
#	print(group[2].texture)
#	pass
	#i=Rect("1")
	#i.texture=load("res://icon.png")
############fyi couldnt do on remove cuz have to compare after why remove stat but before we remove item_type
func additem(slotindex,slotStat,slotTexture,slotItemtype,slotItemrarity):
	group[slotindex].stat=slotStat
	group[slotindex].item_type=slotItemtype
	group[slotindex].texture=slotTexture
	group[slotindex].change_color(slotItemrarity)
func _on_TextureRect3_focus_entered():
	pass # Replace with function body.


func _on_GridContainer_sort_children():
#	print("sorted")
	pass

	##### so load stat on eac texture slot so easy to acces!!! also save on arrray list so easy to save in case anything happen!!
func switchItem(index,end_index):
	if end_index>=group.size():
		end_index=group.size()-1 ## in case array is bigger then we just last node in group!!!
	var init_texture=group[index].texture.resource_path
	var init_stat=group[index].stat
	var init_type=group[index].item_type
	var init_rare=group[index].rarity
	var switch_texture=group[end_index].texture.resource_path
	var switch_stat=group[end_index].stat
	var switch_type=group[end_index].item_type
	var switch_rare=group[end_index].rarity
	additem(index,switch_stat,load(switch_texture),switch_type,switch_rare)
	additem(end_index,init_stat,load(init_texture),init_type,init_rare)

func equip_stat_update(index): # index of equipment slot 0=helm,1=armor,2=acces,3 rh,4=acces lf, 5 lh,6 leg,7shoe
	equip_stat.clear()
	equip_stat.add_text("Equiped")
	equip_stat.newline()
	for i in equipment[index].stat.size()-1:
		if i%2==1:
			continue
		equip_stat.add_text((String(equipment[index].stat[i])+String(equipment[index].stat[i+1])))
		equip_stat.newline()
func compare_stat(itemA,index): #iteama is stat of the item and  index rep index of that item in the slot
	#### slot item stat 
	item_stat_display.clear()
	item_stat_display.add_text("Selected")
	item_stat_display.newline()
	for i in itemA.size()-1:
		if i%2==1: #remainder 0=even, remainder 1 = odd
			continue
		item_stat_display.add_text(String(itemA[i])+String(itemA[i+1])) # have to skip!! ever other i so i can print string and corresponding int
		item_stat_display.newline()
		#print(group[index].item_type) 
	####equiped item stat
	match group[index].item_type:
		"helm":
			equip_stat_update(0)
		"armor":
			equip_stat_update(1)
		"accessory1":
			equip_stat_update(2)
		"sword","staff","axe","weapon2h": # have to specify to rh or 2h
			equip_stat_update(3)
		"accessory2":
			equip_stat_update(4)
		"shield":
			equip_stat_update(5)
		"leg":
			equip_stat_update(6)
		"shoe":
			equip_stat_update(7)
			### add rest of the gear then done!!!!
			pass

func _on_TextureRect_switch_texture(init_pos,end_pos):
	## combine if same food then switch!!
	if group[init_pos].texture.resource_path==group[end_pos].texture.resource_path and group[init_pos].item_type=="food":
		var totalfood=group[init_pos].amount()+group[end_pos].amount()
		if totalfood>100 and end_pos!=init_pos: #if we have combined amount more then 100 then init will get 100 and other will get left over !! then next code will switch we dont need to give end pos 100 right now!!!
			group[init_pos].changeamount(100)##  again this should have total-100 but switch state/textureswitch below will take care of switching it !!!
			group[end_pos].changeamount(totalfood-100)
		elif totalfood<=100 and end_pos!=init_pos:
			group[init_pos].changeamount(totalfood)
			group[end_pos].changeamount(0)
			group[end_pos].stat=[]
			group[end_pos].item_type=""
			group[end_pos].texture=empty_texture
			group[end_pos].rarity=null

	
	
	#### switch texture(init_pos=current item, end_pod=target location/item being switch too
	switchItem(init_pos,end_pos)
	var init_amount=group[init_pos].amount()
	var end_amount=group[end_pos].amount()
	#print(init_amount,end_amount)
	if init_amount>0:
		group[end_pos].changeamount(init_amount)
		if end_amount==0: ## when switching with non food it will change the oop pos aka inital label to 0
			group[init_pos].changeamount(0)
	if end_amount>0:
		group[init_pos].changeamount(end_amount)
		if init_amount==0:## when switching with non food
			group[end_pos].changeamount(0)
	if end_pos==init_pos:
		group[end_pos].changeamount(end_amount)## it dont matter we can do init or end either way its fine so if click on same slot it dont go 0
	compare_stat(group[init_pos].stat,init_pos) #inital click item show on left 2nd on right(group[init].stat,group[end_pos].stat)




### add text pop that show "upgrade finished cost:", "Lack of gold!! total Cost:"
### inc cost to upgrade rare!!!!
func _on_upgrade_button_down(): # 50 just saying nothing is selected! only has at inital or when we reset by delected the select button
	selected_slot=selected_item.slot_selected_get()
	if selected_slot.size()==1 and selected_slot[0]!=50:
		#print(group[selected_slot[0]].item_type," o " ,group[selected_slot[0]])
		#single selection gives index
		### insert upgrade method with arguement that takes arry of node selected!!!
		if group[selected_slot[0]].stat.size()>0:
			#var upgradecost=round(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36)
			#print(group[selected_slot[0]].stat," level  ",upgradecost)
			if group[selected_slot[0]].item_type=="armor" and int(gold.text)>= group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1] and int(metal.text)>=group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]:#and int(gold.text)>=upgradecost*0.8:
				### take out metal
				metal.text=String(int(metal.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]))
				### add hp
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Hp")+1]+=round(.5+(upgradestatype("Hp",1,0.4)-upgradestatype("Hp",0,0.4))/4.5) # changed to 4.5 instead of 5 so its worth more to upgrade then find new piece!!
				#gold.text=str(int(gold.text)-upgradecost*.8)
				#####subtract cost from gold
				gold.text=str(int(gold.text)-group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1])
				### gear upgrade track
				group[selected_slot[0]].stat[1]+=0.2
				### +1 every x lvl
				mcostupgrade(3) # cost inc every 3 lvl
				####value inc of the item
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Value")+1]+=round(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]*.5)
				###cost update
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]=round(.8*(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36))
				### update stat on screen
				compare_stat(group[selected_slot[0]].stat,selected_slot[0])
			
			### problem old gear didnt have mcost so if game updated!! previously saved gear wont get updated unless i add m cost on stat
			elif group[selected_slot[0]].item_type=="leg" and int(gold.text)>= group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1] and int(metal.text)>=group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]:# and int(gold.text)>=upgradecost*.6:
				### take out metal
				metal.text=String(int(metal.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]))
				
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Hp")+1]+=round(.5+(upgradestatype("Hp",1,0.25)-upgradestatype("Hp",0,0.25))/4.5)
				#gold.text=str(int(gold.text)-upgradecost*.6)
				gold.text=str(int(gold.text)-group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1])
				group[selected_slot[0]].stat[1]+=0.2
				### +1 every x lvl
				mcostupgrade(3) # cost inc every 3 lvl
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Value")+1]+=round(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]*.5)
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]=round(.6*(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36)) 
				compare_stat(group[selected_slot[0]].stat,selected_slot[0])
			elif group[selected_slot[0]].item_type=="shoe" and int(gold.text)>= group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1] and int(metal.text)>=group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]:# and int(gold.text)>=upgradecost*.55:
				metal.text=String(int(metal.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]))
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Hp")+1]+=round(.5+(upgradestatype("Hp",1,0.225)-upgradestatype("Hp",0,0.225))/4.5)
				#gold.text=str(int(gold.text)-upgradecost*.55)
				gold.text=str(int(gold.text)-group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1])
				group[selected_slot[0]].stat[1]+=0.2
				mcostupgrade(3)
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Value")+1]+=round(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]*.5)
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]=round(.55*(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36))
				compare_stat(group[selected_slot[0]].stat,selected_slot[0])
				#round((round(0.5+(group[selected_slot[0]].stat[1]+1)*log(group[selected_slot[0]].stat[1]+2)*11*upgradetypeboast)-round(-0.5+group[selected_slot[0]].stat[1]*log(group[selected_slot[0]].stat[1]+1)*11*upgradetypeboast))/5)
			elif group[selected_slot[0]].item_type=="helm" and int(gold.text)>= group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1] and int(metal.text)>=group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]:# and int(gold.text)>=upgradecost*.3:
				metal.text=String(int(metal.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]))
				#gold.text=str(int(gold.text)-upgradecost*.3)
				gold.text=str(int(gold.text)-group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1])
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Hp")+1]+=round(.5+(upgradestatype("Hp",1,0.125)-upgradestatype("Hp",0,0.125))/4.5)
				group[selected_slot[0]].stat[1]+=0.2
				mcostupgrade(3)
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Value")+1]+=round(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]*.5)
				group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]=round(.3*(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36))
				compare_stat(group[selected_slot[0]].stat,selected_slot[0])
			elif group[selected_slot[0]].item_type!="food" and int(gold.text)>= (group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1] ) and int(metal.text)>=group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]:# int(gold.text)>=upgradecost:
				if group[selected_slot[0]].item_type=="axe" or group[selected_slot[0]].item_type=="weapon2h" or group[selected_slot[0]].item_type=="sword" or group[selected_slot[0]].item_type=="staff":
					metal.text=String(int(metal.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]))
					group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("baseatk")+1]+=stepify((upgradestatype("baseatk",1,0.72)-upgradestatype("baseatk",0,0.72))/3,.01)#chaning .46 to .72 and 4.5 to 3#120% every lvl and drop is 50-70%# its 0 and 1 because we doing stat@lvl+1-stat@lvl-0
					#gold.text=str(int(gold.text)-upgradecost)
					gold.text=str(int(gold.text)-int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]))
					group[selected_slot[0]].stat[1]+=0.2
					mcostupgrade(2)# should make it every 1 cuz getting a lot more dmg per lvl from upgrade then drop
					#print(group[selected_slot[0]].stat[1],group[selected_slot[0]].stat[0])
					group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Value")+1]+=round(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]*.5)
					group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cost")+1]=round(.0018*pow(group[selected_slot[0]].stat[1],2)+8.8*group[selected_slot[0]].stat[1]+36)
					compare_stat(group[selected_slot[0]].stat,selected_slot[0])
			else:
				pass

	elif selected_slot.size()>=2 :
		if selected_slot.has(50):
			selected_slot.remove(selected_slot.find(50))
		for i in selected_slot.size()-1:
			#print(i, selected_slot.size())
			#print(group[selected_slot[i]].stat)
			pass
			######to clean code i could just make sep func for 2h and another function to switch shield when 2h equip!! 
	#######i could have just made sep func for 2h and call equip gear method multiple time then rewriting ex  empty right, empty left equip(3), right empty, left not empty manually save current shield and use switch(3) for weapon etc
	# right hand empty=> left hand empty or left hand not empty
	# right hand not empty => left hand empty or left hand not empty => look for empty_slot if left hand not empty

func mcostupgrade(mcostinc): # +1 after mcostinc amount of upgrade!! ex mcostinc=1= every 1 lvl upgrade means +1metal cost  also can also include cost but meh
	if int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("level")+1])%mcostinc==0 and (step_decimals(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("level")+1]))==0:# 
		group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("M Cost")+1]+=1
func upgradestatype(statname,level,boasttype):
	if statname=="Hp":
		return ((2*level+group[selected_slot[0]].stat[1])*log(1+group[selected_slot[0]].stat[1]+1)*10*boasttype)
	elif statname=="baseatk":
		return ((-3.6+4.647*(level+group[selected_slot[0]].stat[1])+0.03465*pow(level+group[selected_slot[0]].stat[1],2))*boasttype)



func equip_gear(gear_index): #may be stat will be weird with random stat and stuff tho maybe! # i could create a resource with item type and stat that way it auto switch when i load the texture thorugh tres file!!!! just like slot tres auto fill resource name!!!!
	if group[selected_slot[0]].item_type=="weapon2h"  or group[selected_slot[0]].item_type=="axe" : # cant skip some code cuz it get trigger when its 2h sword so cant skip lh emp,rh emp, lh emp,rh no emp# 2h sword sep cuz we have to remove shield and current equipment
		if equipment[gear_index].texture.resource_name=="empty_slot": # weapon hand empty add weapon
			equipment[gear_index].texture= load(group[selected_slot[0]].texture.resource_path)
			equipment[gear_index].stat=group[selected_slot[0]].stat
			equipment[gear_index].item_type=group[selected_slot[0]].item_type
			equipment[gear_index].rarity=group[selected_slot[0]].rarity
			# update stat on empty slot!!!
			equip_stat.clear()
			equip_stat.add_text("Equiped")
			equip_stat.newline()
			for i in equipment[3].stat.size()-1:
				if i%2==1:
					continue
				equip_stat.add_text((String(equipment[3].stat[i])+String(equipment[3].stat[i+1])))
				equip_stat.newline()
			if equipment[5].texture.resource_name=="empty_slot": # checking shield
				additem(selected_slot[0],[],empty_texture,"",null)

			else: ### shield equiped!!! but weapon hand empty so no need to check empty slot!!! we can just switch
				additem(selected_slot[0],equipment[5].stat,load(equipment[5].texture.resource_path),equipment[5].item_type,equipment[5].rarity)

				equipment[5].stat=[]
				equipment[5].item_type="" #can say shield but meh
				equipment[5].texture=empty_texture
				equipment[5].rarity=null
				emit_signal("stat_to_player",[],"shield")
		elif equipment[5].texture.resource_name=="empty_slot": # equiped weapon but no shield
			var equip_texture=equipment[gear_index].texture.resource_path
			var equip_stats=equipment[gear_index].stat
			var equip_item_type=equipment[gear_index].item_type
			var equip_item_rarity=equipment[gear_index].rarity
			equipment[gear_index].texture= load(group[selected_slot[0]].texture.resource_path)
			equipment[gear_index].stat=group[selected_slot[0]].stat
			equipment[gear_index].item_type=group[selected_slot[0]].item_type
			equipment[gear_index].rarity=group[selected_slot[0]].rarity
			additem(selected_slot[0],equip_stats,load(equip_texture),equip_item_type,equip_item_rarity)

		else: # already equiped weapon and shield
			for i in range(group.size()):
				if group[i].texture.resource_name=="empty_slot":# check if slot empty! then add 2h sword and remove shield and weapon add weapon to switched slot and shield to empty slot
					var equip_texture=equipment[gear_index].texture.resource_path
					var equip_stats=equipment[gear_index].stat
					var equip_item_type=equipment[gear_index].item_type
					var equip_item_rarity=equipment[gear_index].rarity
					equipment[gear_index].texture= load(group[selected_slot[0]].texture.resource_path)
					equipment[gear_index].stat=group[selected_slot[0]].stat
					equipment[gear_index].item_type=group[selected_slot[0]].item_type
					equipment[gear_index].rarity=group[selected_slot[0]].rarity
					additem(selected_slot[0],equip_stats,load(equip_texture),equip_item_type,equip_item_rarity)

					# switchshield
					additem(i,equipment[5].stat,load(equipment[5].texture.resource_path),equipment[5].item_type,equipment[5].rarity)

					equipment[5].stat=[]
					equipment[5].item_type="" #can say shield but meh
					equipment[5].texture=empty_texture
					equipment[5].rarity=null
					emit_signal("stat_to_player",[],"shield")
					break # switch gear and add shield to empty slot# other wise it will do nothing! cuz no slot open to remove shield 
			
			pass # check if weaponlh has any item! if it dont have weapon then we can remove shield if wearning and add 2h but ! if it has a weapon then check empty slot so wecan remove shield and switch weapon or make funct for thiscase!
	# add gear to equipment and add empty to slot
	elif equipment[gear_index].texture.resource_name=="empty_slot": # all other gear equip # check if it has texture and if it dont add texture,stat,type to equpoment and remove from slot
		equipment[gear_index].texture= load(group[selected_slot[0]].texture.resource_path)
		equipment[gear_index].stat=group[selected_slot[0]].stat
		equipment[gear_index].item_type=group[selected_slot[0]].item_type
		equipment[gear_index].rarity=group[selected_slot[0]].rarity
		additem(selected_slot[0],[],empty_texture,"",null)

		# other slot will be empty so it has nothign to compare we have to manually update equiped gear stat
		equip_stat.clear()
		equip_stat.add_text("Equiped")
		equip_stat.newline()
		for i in equipment[gear_index].stat.size()-1:
			if i%2==1:
				continue
			equip_stat.add_text((String(equipment[gear_index].stat[i])+String(equipment[gear_index].stat[i+1])))
			equip_stat.newline()
	else: # switch gear between slot and equipment
		var equip_texture=equipment[gear_index].texture.resource_path
		var equip_stats=equipment[gear_index].stat
		var equip_item_type=equipment[gear_index].item_type
		var equip_item_rarity=equipment[gear_index].rarity
		equipment[gear_index].texture= load(group[selected_slot[0]].texture.resource_path)
		equipment[gear_index].stat=group[selected_slot[0]].stat
		equipment[gear_index].item_type=group[selected_slot[0]].item_type
		equipment[gear_index].rarity=group[selected_slot[0]].rarity
		additem(selected_slot[0],equip_stats,load(equip_texture),equip_item_type,equip_item_rarity)




func _on_equip_pressed():
	selected_slot=selected_item.slot_selected_get()
	if tut==1:
		if selected_slot[0]!=50:
			if group[selected_slot[0]].item_type!=null:
				#tutmessage.rect_position=Vector2(35,494)
				canalert=false# now we have to unequip and sell it
				tut=2
				update()
				#tutmessage.dialog_text="Unequip the gear and sell it to proceed!! \n1.click on gear(to view current equip gear) \n2.click on the item to unequip \n3.Select the slot with the weapon \n4.click on sell and then confirm to sell it"
	if selected_slot.size()==1 and selected_slot[0]!=50:
		match group[selected_slot[0]].item_type:
			"helm":
				equip_gear(0)
				emit_signal("stat_to_player",equipment[0].stat,"helm") ### can also emit which gear was worn and etc!!! and then add those stat to player current stat and when removed/worn diff gear take the stat off from prev item
			"armor":
				equip_gear(1)
				emit_signal("stat_to_player",equipment[1].stat,"armor")
			"accessory1":
				equip_gear(2)
				emit_signal("stat_to_player",equipment[2].stat,"accessory1")
			"sword","staff","axe": # weponrh
				equip_gear(3)
				emit_signal("stat_to_player",equipment[3].stat,equipment[3].item_type)
			"weapon2h": ### recent do same as shield(where 2h is equped) but also include the case where both shield and weapon are equiped
				equip_gear(3) # i could have just done if shield equip check empty space and remove else break so it dont equip 2h instead of all this code!
				emit_signal("stat_to_player",equipment[3].stat,"weapon2h")
			"accessory2":
				equip_gear(4)
				emit_signal("stat_to_player",equipment[4].stat,"accessory2")
			"shield":
				if equipment[3].item_type=="weapon2h": # lh gona be empty cuz its 2h so we dont have to worry about lh 
					var equip_texture=equipment[3].texture.resource_path
					var equip_stats=equipment[3].stat
					var equip_item_type=equipment[3].item_type
					var equip_item_rarity=equipment[3].rarity
					equip_gear(5)
					equipment[3].texture= empty_texture
					equipment[3].stat=[]
					equipment[3].item_type=""
					equipment[3].rarity=null
					additem(selected_slot[0],equip_stats,load(equip_texture),equip_item_type,equip_item_rarity)

					emit_signal("stat_to_player",[],"weapon2h") 
				elif equipment[3].item_type=="axe":
					var equip_texture=equipment[3].texture.resource_path
					var equip_stats=equipment[3].stat
					var equip_item_type=equipment[3].item_type
					var equip_item_rarity=equipment[3].rarity
					equip_gear(5)
					equipment[3].texture= empty_texture
					equipment[3].stat=[]
					equipment[3].item_type=""
					equipment[3].rarity=null
					additem(selected_slot[0],equip_stats,load(equip_texture),equip_item_type,equip_item_rarity)

					emit_signal("stat_to_player",[],"axe") 
				else:
					equip_gear(5)
				emit_signal("stat_to_player",equipment[5].stat,"shield")
			"leg":
				equip_gear(6)
				emit_signal("stat_to_player",equipment[6].stat,"leg")
			"shoe":
				equip_gear(7)
				emit_signal("stat_to_player",equipment[7].stat,"shoe")
		compare_stat(group[selected_slot[0]].stat,selected_slot[0]) # show updated stat after switching
			
	pass # Replace with function body.


func _on_sell_pressed():

	if tut==2: ## for tut
		if canalert==true:
			alert("can not sell yet !!!","tutorial")
		else:
			selected_slot=selected_item.slot_selected_get()
			if selected_slot[0]!=50:
				if group[selected_slot[0]].item_type!="":
					sellmultiamount.popup()
					
					tut=3
					tutmessage.get_ok().visible=true
					update()
					#tutmessage.visible=false
	else: 
		sellmultiamount.popup()

func alert(text: String, title: String='Message') -> void:
	canalert=false
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.window_title = title
	add_child(dialog)
	dialog.popup_centered()
	yield(get_tree().create_timer(2),"timeout")
	dialog.queue_free()
	canalert=true

func remove_item(slotpositions,valuesize,eat:bool=false):
	if group[slotpositions].stat.size()>0 and group[slotpositions].amount()==0: # this means not food since null gives 0
		if eat==false: # for eating dont need to sell
			gold.text=String(int(gold.text)+group[slotpositions].stat[group[slotpositions].stat.find("Value")+1])
		group[slotpositions].stat=[]
		compare_stat(group[slotpositions].stat,slotpositions) ### have to compare before we make item type null cuz we need it to compare/ update stat display
		group[slotpositions].item_type=""
		group[slotpositions].texture=empty_texture
		group[slotpositions].rarity=null
	elif group[slotpositions].stat.size()>0 and group[slotpositions].amount()>=1: ## if null aka nothing then we get 0!!
		if valuesize >=group[slotpositions].amount():#selling more food then i have so sell max amount
			if eat==false:
				gold.text=String(int(gold.text)+(group[slotpositions].stat[group[slotpositions].stat.find("Value")+1]*group[slotpositions].amount()))
			group[slotpositions].stat=[]
			group[slotpositions].item_type=""
			group[slotpositions].texture=empty_texture
			group[slotpositions].rarity=null
			group[slotpositions].changeamount(0)
		else:
			gold.text=String(int(gold.text)+(group[slotpositions].stat[group[slotpositions].stat.find("Value")+1]*valuesize))
			group[slotpositions].changeamount(group[slotpositions].amount()-valuesize)
	

func _on_equiped_focus_entered(gear):
	#print(gear)
	for i in range(group.size()):
			if group[i].texture.resource_name=="empty_slot":
				group[i].texture=load(equipment[gear].texture.resource_path)
				group[i].stat=equipment[gear].stat
				group[i].item_type=equipment[gear].item_type
				group[i].rarity=equipment[gear].rarity
				equipment[gear].texture=empty_texture
				equipment[gear].stat=[]
				equipment[gear].rarity=null
				emit_signal("stat_to_player",equipment[gear].stat,equipment[gear].item_type)
				equipment[gear].item_type=""
				break
	pass

func saveinventoryinfo():
	var inventorydata=[[],[],[],[],[],[],[],[],[],[],[]]
	# tut
	inventorydata[10].append(canalert)
	inventorydata[10].append(tut)
	inventorydata[10].append(tabdisable)
	#
	for i in range(group.size()):
		inventorydata[0].append(group[i].stat)
		inventorydata[1].append(group[i].item_type)
		inventorydata[2].append(group[i].texture.resource_path)
		inventorydata[7].append(group[i].rarity)
		inventorydata[9].append(group[i].amount())
	inventorydata[3].append(gold.text)
	inventorydata[3].append(metal.text)
	#print(inventorydata[3])
	for i in range(equipment.size()):
		inventorydata[4].append(equipment[i].stat)
		inventorydata[5].append(equipment[i].item_type)
		inventorydata[6].append(equipment[i].texture.resource_path)
		inventorydata[8].append(equipment[i].rarity)
	save_load.save_game("inventoryinfo",inventorydata)
func loadinventoryinfo():
	var inventoryinfom=save_load.load_game()
	if inventoryinfom.has("inventoryinfo"):
		gold.text=inventoryinfom.inventoryinfo[3][0]
		metal.text=inventoryinfom.inventoryinfo[3][1]
		canalert=inventoryinfom.inventoryinfo[10][0]
		tut=inventoryinfom.inventoryinfo[10][1]
		tabdisable=inventoryinfom.inventoryinfo[10][2]
		for i in range(group.size()):
			group[i].stat=inventoryinfom.inventoryinfo[0][i]
			group[i].item_type=inventoryinfom.inventoryinfo[1][i]
			group[i].texture=load(inventoryinfom.inventoryinfo[2][i])
			group[i].change_color(inventoryinfom.inventoryinfo[7][i])
			group[i].changeamount(inventoryinfom.inventoryinfo[9][i])
		for i in range(equipment.size()):
			equipment[i].stat=inventoryinfom.inventoryinfo[4][i]
			equipment[i].item_type=inventoryinfom.inventoryinfo[5][i]
			equipment[i].texture=load(inventoryinfom.inventoryinfo[6][i])
			equipment[i].rarity=inventoryinfom.inventoryinfo[8][i]
			
func _on_saveButton_pressed(): ## took out save button just neeed to add new
	saveinventoryinfo()


func _on_sellconfirmButton_pressed():

	selected_slot=selected_item.slot_selected_get()
	if selected_slot.size()==1 and selected_slot[0]!=50: # single slot ! in array hence why we have to do [0] to get first index			#print("wahh ",group[selected_slot[0]])
			remove_item(selected_slot[0],sellmultiamount.currentscrollamount()) # instead of 0 need to add amount
	elif selected_slot.size()>=2 : # multiple slot
		if selected_slot.has(50): ## in case selectedslot has default value of 50  
			selected_slot.remove(selected_slot.find(50))
		for i in selected_slot.size(): # all selected slot!! # should been size()-1 but its work fine without it not sure why
			#print("test ",group[selected_slot[i]].stat)
			remove_item(selected_slot[i],sellmultiamount.currentscrollamount())
	sellmultiamount.hide()



func foodslot(needcure):  #(currenteffect):
	selected_slot=selected_item.slot_selected_get()
	var cured:Array=[]# avoid multiple return !!! we just save info in this var
	if selected_slot.size()==1 and selected_slot[0]!=50 and group[selected_slot[0]].item_type=="food":
		if group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+1]=="Hp heal":
			cured.append("Hp heal")
			cured.append( int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Hp")+1]))
			remove_item(selected_slot[0],1,true)
		elif group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+1]=="buff":
			cured.append("buff") ### buff,skill being buff , amount of the buff,buff time
#			print(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+2],group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+1])
			cured.append( str(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+2]))
			cured.append( int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+3]))
			cured.append( int(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+5]))
			remove_item(selected_slot[0],1,true)
			print(cured)
		else: # gen cure like stun, or knock
			if needcure.has(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+1]):
				cured.append(group[selected_slot[0]].stat[group[selected_slot[0]].stat.find("Cure ")+1])
				remove_item(selected_slot[0],1,true)
			else:
				cured.append("empty")
	else:
		cured.append("empty")
	return cured
	
	
	


