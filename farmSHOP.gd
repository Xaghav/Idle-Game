extends PopupPanel
#### add tile then move -12, add name and time in farm map! add tabs in shop then  pic of seed in item array
###, then add pic loc of pick up then add number and name in pickup func!! last change dict on cook node aswell !!! 
const limitamount=100
onready var amount=get_node("HSplitContainer/VBoxContainer2/CenterContainer5/amount")
onready var price=get_node("HSplitContainer/VBoxContainer2/CenterContainer2/Label2")
onready var texture=get_node("HSplitContainer/VBoxContainer2/CenterContainer/TextureRect")
onready var farmslottexture=get_tree().get_nodes_in_group("farmslot")
onready var farmslotlabel=get_tree().get_nodes_in_group("farmlabel")
onready var images=load("res://resource/images/farm/farminven.tres")#load("res://resource/images/farm/farm.tres")
onready var arrow=load("res://resource/images/farm/arrow.png")
onready var emptyslot=load("res://resource/images/slot.tres")
onready var group= get_tree().get_nodes_in_group("shopitem")
onready var save_load=load("res://resource/game/save.gd").new()
onready var sellwindow=get_node("../../../WindowDialog")
onready var sellamountlabel=get_node("../../../WindowDialog/Label")
onready var sellamountslider=get_node("../../../WindowDialog/HSlider")
var Itemresource=preload("res://resource/game/recipeAndIngrident.tres")
var currentfarmslot=0
var currentsellamount=1
var button=[0]
 ##### shows the images in the shop
var item=Itemresource.item
			#### we send region to text rect aka slot script!! these are drop images!!!
var invenitem=Itemresource.invenitem
var sellprice=Itemresource.sellprice
onready var gold=get_tree().get_root().get_child(0).get_node("Panel/Label")#100000# change whole words gold to int(gold.text) and subtract gold on buy  # current amount of gold has going to change it later where we get value from player
var selected_item:String="WaterCan"
var selected_itemtype:String=item["WaterCan"][2]
var selected_amount=1
var selected_price
var selected_inital_amount=1 ## plug the value back after it update inventory because we update selected_amount with remaing amount when updating inventory 
var initalsellamount=1
onready var cookinghelp=get_node("../../../AcceptDialog")
onready var cookinghelpbutton=get_node("../../../CheckBox")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal itempicked
signal sellfocus
# Called when the node enters the scene tree for the first time.
func _ready():
	loadfarminv()
	#farmslottexture[0].farmitem="WaterCan" ## able to update name of item bought
#	print(farmslottexture[0].get_child(0).text)
	#### initally set shop item to 1 aka watercan 
	amount.text="Amount: 1"
	price.text="Price :"+str(item.WaterCan[0])
	images.region=item["WaterCan"][1]
	texture.texture=images
	group[0].texture_normal=arrow
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# shop ui slider amount changes price value and selected amount label
func _on_HSlider_value_changed(value):
	amount.text="Amount: "+str(value)
	price.text="Price :"+str(item[selected_item][0]*value)
	selected_amount=int(value)
	selected_inital_amount=int(value)
	selected_price=int(item[selected_item][0]*value)
	

#### shop ui item update
func _on_TextureButton_toggled(_button_pressed,itemname):
	### add arrow on the selected item
	for i in range(group.size()):
		group[i].name
		if group[i].name==itemname:
			#print(i)
			button.append(i)
	
	if button.size()==2:
		group[button[0]].texture_normal=null
		button.remove(0)
		group[button[0]].texture_normal=arrow
		####update selected item info
	selected_item=itemname
	selected_itemtype=item[selected_item][2]
	price.text="Price :"+str(item[selected_item][0])
	images.region=item[selected_item][1]
	texture.texture=images
	pass




### buy item check for slot with same item and less then 100- check if has enough money
# then check if totally empty slot then check if enough money lastly check if no slot open and exit!
func _on_Buy_button_down():
	### add 1 more if to make sure player has more money then they (selected_price)spending if not then this wont run or let them buy max amount they can
	## 
	var a=true # change to remaining amount
	var itemnotfound=false
	while a==true:
		for i in range(farmslottexture.size()):##update existing slot with same item
			if farmslottexture[i].farmitem==selected_item and not int(farmslotlabel[i].text)>=100: # if same item exist then look if total amount can fit in one slot if not add rest to 100 and change selected amount to remaining or if it fit in on slot then add all to that slot
				var goldcheck=selected_amount*item[selected_item][0]
				if goldcheck>int(gold.text): # not enough gold 
					selected_amount=int(gold.text)/item[selected_item][0] # selected amount now change to amount of item you can buy
				selected_amount=updateLabel(farmslotlabel[i],selected_amount)# buy until slot is full then updated selected amount to the remain left to buy and it will loop again
				farmslottexture[i].amountupdate(farmslotlabel[i].text) # so i can update alch
				if selected_amount<=0:# no item remaings to buy aka bought all or asmuch as you could for same slot
					selected_amount=selected_inital_amount
					a=false
					break
			elif itemnotfound==false:# went through the loop and didnt find identical item so now it can look for empty slot aka go through rest of the elif to either buy the reaming or for new slot!!
				if i==farmslottexture.size()-1:
					itemnotfound=true
			elif farmslotlabel[i].text=="0" :### find emptyslot
				var goldcheck=selected_amount*item[selected_item][0]
				if goldcheck>int(gold.text):# not enough gold
					selected_amount=int(gold.text)/item[selected_item][0] # buy what u can
				if selected_amount==0:
					a=false
					break
				updateLabel(farmslotlabel[i],selected_amount)
				farmslottexture[i].farmitem=selected_item
				farmslottexture[i].farmitemtype=selected_itemtype
				farmslottexture[i].slotupdate(item[selected_item][1])
				###################farmslottexture[i].texture=  ## need to draw seed texture 
				selected_amount=selected_inital_amount
				a=false
				break
			elif farmslotlabel[i].text!="0" and i==farmslottexture.size()-1: # no room to buy
				selected_amount=selected_inital_amount
				a=false
	pass
	### inventory slot amount update!!!!
func updateLabel(labelnode,invamount):# invamount=selected_amount...
	
	var currentamount=int(labelnode.text)
	#print(invamount,currentamount)
	var totalamount=invamount+currentamount
	var remaining=0
	if totalamount<limitamount:
		labelnode.text=str(currentamount+invamount)
	else:
		labelnode.text=str(limitamount)
		remaining=totalamount-limitamount
	gold.text=str(int(gold.text)-(selected_amount-remaining)*item[selected_item][0])# remaing item in case no room in invtory so refund gold
	return remaining


func _on_farm_seedplanted(labelnodepos,amountleft):
	farmslotlabel[labelnodepos].text=String(amountleft)
	farmslottexture[labelnodepos].amountupdate(farmslotlabel[labelnodepos].text)
	if amountleft==0:
		farmslottexture[labelnodepos].texture_normal=emptyslot
		farmslottexture[labelnodepos].farmitem="empty"
		farmslottexture[labelnodepos].farmitemtype="empty"


func _on_farm_plantgrown(plantname,plantpos): ### can use for auto place in inventory!!!

	### add to inventory with image!!!
	pass # Replace with function body.


func addtoinv(_item,amount):
	for i in range(farmslottexture.size()):# check for same item
		#print(farmslottexture[i].farmitem,farmslotlabel[i].text)
		if _item=="sand" and farmslottexture[i].farmitem==_item: # add unlimited sand to same slot
			farmslotlabel[i].text=str(int(farmslotlabel[i].text)+amount)
			farmslottexture[i].amountupdate(farmslotlabel[i].text) # just for signal so can update alch inventory
			return true
		elif farmslottexture[i].farmitem==_item and not int(farmslotlabel[i].text)>=100:
			farmslotlabel[i].text=str(int(farmslotlabel[i].text)+amount)
			farmslottexture[i].amountupdate(farmslotlabel[i].text) # just for signal so can update alch inventory
			return true
	for i in range(farmslottexture.size()): # now check for empty slot
		if farmslotlabel[i].text=="0":
			farmslotlabel[i].text=str(int(farmslotlabel[i].text)+amount)
			farmslottexture[i].farmitem=_item
			farmslottexture[i].farmitemtype=invenitem[_item][1]
			farmslottexture[i].slotupdate(invenitem[_item][0])
			return true
	return false

func _on_farm_plantpickup(plant,farmpos):
	match plant:
		18:
			emit_signal("itempicked",addtoinv("carrot",4),farmpos) #just remove from array in farm script # cant say plant 1 cuz thats forseed
		19:
			emit_signal("itempicked",addtoinv("herb",4),farmpos)
		20:
			emit_signal("itempicked",addtoinv("corn",4),farmpos)
		21:
			emit_signal("itempicked",addtoinv("radish",4),farmpos)
		22:
			emit_signal("itempicked",addtoinv("sugarcane",4),farmpos)
		23:
			emit_signal("itempicked",addtoinv("mushroom",4),farmpos)
		24:
			emit_signal("itempicked",addtoinv("wheat",4),farmpos)
func removefromInv(slotcurrentpos,amounttoremove):
	if int(farmslotlabel[slotcurrentpos].text)-amounttoremove<0: # in case we somehow get - value lets say some reason slot has 0 and cooking ingrident still has item if it fnish cooking then when it remove e will have -1 in slot... tho need to stop that from happening too
		amounttoremove=(int(farmslotlabel[slotcurrentpos].text)-amounttoremove)+amounttoremove
	farmslotlabel[slotcurrentpos].text=String(int(farmslotlabel[slotcurrentpos].text)-amounttoremove)
	farmslottexture[slotcurrentpos].amountupdate(farmslotlabel[slotcurrentpos].text)
	if int(farmslotlabel[slotcurrentpos].text)==0:
		farmslottexture[slotcurrentpos].texture_normal=emptyslot
		farmslottexture[slotcurrentpos].farmitem="empty"
		farmslottexture[slotcurrentpos].farmitemtype="empty"
		pass
	
func savefarminv():
	var farminv=[[],[],[]]
	for i in range(farmslottexture.size()):
		farminv[0].append(farmslotlabel[i].text)
		farminv[1].append(farmslottexture[i].farmitem)
		farminv[2].append(farmslottexture[i].farmitemtype)
	save_load.save_game("farminventory",farminv)
func loadfarminv():
	var farminventorydata=save_load.load_game()
	if farminventorydata.has("farminventory"):
		for i in range(farmslottexture.size()):
	#################
#			match farminventorydata.farminventory[1][i]:
#				"watercan","plant1","plant2","plant3","plant4","plant5","plant6":
#					farmslottexture[i].slotupdate(item[farminventorydata.farminventory[1][i]][1])
#				"carrot","herb","corn","radish","sugarcane","mushroom":# _ for default / all othercase
#					farmslottexture[i].slotupdate(invenitem[farminventorydata.farminventory[1][i]][0])
  ######################or
			match farminventorydata.farminventory[2][i]:
				"seed","tool":
					farmslottexture[i].slotupdate(item[farminventorydata.farminventory[1][i]][1])
				"recipe":
					farmslottexture[i].slotupdate(invenitem[farminventorydata.farminventory[1][i]][0])
			farmslotlabel[i].text=str(farminventorydata.farminventory[0][i])
			farmslottexture[i].farmitem=farminventorydata.farminventory[1][i]
			farmslottexture[i].farmitemtype=farminventorydata.farminventory[2][i]
### sell button press sell option window popsup then initally we check how many item we have and amount we selling!! and list it price in the window title
### currentslotselected func check if we have item in slot then
###slider function checks amount we selling and if we have that amount window title list the price and update currentsellamount variable
###then sell button press sells the item via  sellitem() function which adds gold to the inventroy
### sell button pressed
func _on_sellButton_pressed():
	if int(farmslotlabel[currentfarmslot].text)>0: #for visual# make sure intially we have the amount of item in inventory to sell ### fyi slider update it but if we dont move the slider we need to update here !!! to make sure we have the item
		if currentsellamount>int(farmslotlabel[currentfarmslot].text):# selling more then in inventory
			currentsellamount=int(farmslotlabel[currentfarmslot].text)
		sellamountslider.value=currentsellamount
		sellwindow.window_title="Selling "+str(currentsellamount)+" item in slot "+str(currentfarmslot+1)+" for "+str(sellprice[farmslottexture[currentfarmslot].farmitem]*currentsellamount)+"gold"
	sellwindow.popup()

### signal from farm tell current selected slot pos 
func _on_farm_currentslotselected(farmslot):
	currentfarmslot=farmslot
	pass
#### sell function
func sellitem():
	if int(farmslotlabel[currentfarmslot].text)>0:
		var price=sellprice[farmslottexture[currentfarmslot].farmitem]
		if currentsellamount>int(farmslotlabel[currentfarmslot].text):#checking here again in case they were cooking something and the item was removed!!!!# selling more then in inventory
			currentsellamount=int(farmslotlabel[currentfarmslot].text)
			
		removefromInv(currentfarmslot,currentsellamount)
		gold.text=str(int(gold.text)+price*currentsellamount)
##### sell confirm button
func _on_Button_pressed():
	sellitem()
	sellwindow.visible=false
	#### update current inventory slot for farming
	emit_signal("sellfocus",currentfarmslot,farmslottexture[currentfarmslot].farmitem,farmslottexture[currentfarmslot].farmitemtype,farmslotlabel[currentfarmslot].text)
	pass # Replace with function body.

#### amount trying to sell signal from hslider
func _on_HSlider_sellvalue_changed(svalue):

	currentsellamount=svalue
	sellamountlabel.text=str(svalue)
	print(svalue)
	if int(farmslotlabel[currentfarmslot].text)>0:
		if currentsellamount>int(farmslotlabel[currentfarmslot].text):#for visual ref# selling more then in inventory
			currentsellamount=int(farmslotlabel[currentfarmslot].text)
		sellamountslider.value=currentsellamount
		sellwindow.window_title="Selling "+str(currentsellamount)+" item in slot "+str(currentfarmslot+1)+" for "+str(sellprice[farmslottexture[currentfarmslot].farmitem]*currentsellamount)+"gold"


func _on_CheckBox_toggled(button_pressed):
	cookinghelp.visible=button_pressed


func _on_AcceptDialog_confirmed():
	cookinghelpbutton.pressed=false
	pass # Replace with function body.
