####cookign tut stat with ingrident can be obtained from farming or random drop from enemy!!!
extends Node2D   ## was going to use as tool for farming but now gona use for cooking
### price dont really matter here...
var itemresource=preload("res://resource/game/recipeAndIngrident.tres")
var item=itemresource.item
			#### we send region to text rect aka slot script!! these are drop images!!!
var invenitem=itemresource.invenitem
onready var cookslots=get_tree().get_nodes_in_group("cookslot")
onready var ingredientslots=get_tree().get_nodes_in_group("ingredientslot")
onready var ingredientamount=get_tree().get_nodes_in_group("ingredientamount")
onready var ingredientname=get_tree().get_nodes_in_group("ingredientname")
onready var save_load=load("res://resource/game/save.gd").new()
onready var cookingbutton=get_node("CookButton")
onready var ShopFarmslot=get_tree().get_root().get_child(0).get_node("inventory/CenterContainer_inv/TabContainer/farm/farm/ScrollContainer/CenterContainer/SHOP")
onready var inventoryslot=get_tree().get_root().get_child(0).get_node("inventory/CenterContainer_inv/TabContainer/inventory/invetest")
var cook
var timer
var cooking="nothappening"
onready var dialogtext=get_node("AcceptDialog")
var cooknotification=true

var recipes=itemresource.recipes
var recipesname=itemresource.recipesname
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	var a={"a":[],"v":[]}
#	print(a.keys().size())
#	print(a.has_all(["v"]),"aaaa")
	loadfarminv()
	pass # Replace with function body.

func amountchange(nodposition,amounts):
	cookslots[nodposition].camountupdate(amounts)
	#######update ingrident anytime we sell item!!!!
	var ingridentout=false
	if cookingbutton.text=="Stop Cooking":
		if cooking=="nothappening":#dont run when we remove from finishcooking() since that uses the amount from ingridentslot and func below resets amount in igridentslot
			for i in range(ingredientslots.size()):
				if int(cookslots[ingredientslots[i].slotposition].returncamount())>ingredientslots[i].haveduplicate: # amount in cooking slot is more then current duplicate are updated when ingrident is added!!!
					ingredientslots[i].changeingredientamount(cookslots[ingredientslots[i].slotposition].returncamount())
				else:
					ingridentout=true
					ingredientslots[i].addingredient(Rect2(Vector2.ZERO,Vector2.ZERO),0,"Ingrident","empty","none",0)
			if ingridentout==true:
				cookingbutton.text=="Start Cooking"
				if cook.is_valid():
					cook.resume() # can do resume(print("a")) now on yield it will print a instead of doing the timer# stop the yield timer!pretty much instantly finished the timer but the if ..=" stop cooking" will prevent from sucessfully cooking last 3rd line in keepcooking()!!!!!
					timer.unreference()
					timer=null
	else:
#		startcooking()
		for i in range(ingredientslots.size()):
			if ingredientslots[i].texture_normal.resource_name!="empty_slot":
				##added this extra if cuz everytime item drop like sand this function will run so we have make make sure we have enough item or it would make the slot empty
				if int(cookslots[ingredientslots[i].slotposition].returncamount())>ingredientslots[i].haveduplicate: # amount in cooking slot is more then current duplicate are updated when ingrident is added!!!
					ingredientslots[i].changeingredientamount(cookslots[ingredientslots[i].slotposition].returncamount())
				else:
					ingredientslots[i].addingredient(Rect2(Vector2.ZERO,Vector2.ZERO),0,"Ingrident","empty","none",0)
	
func additemtoslot(nodeposition,region,amount,iname,itype):
	cookslots[nodeposition].cslotupdate(region,amount,iname,itype)
func loadfarminv():# have to do it here cuz this scene load after farm inv so this dont get called on ready function i think# since cook inv is just copy of farm inventory
	var farminv=save_load.load_game()
	if farminv.has("farminventory"):
		for i in range(cookslots.size()):
			match farminv.farminventory[2][i]:
				"seed","tool":
					cookslots[i].cslotupdate(item[farminv.farminventory[1][i]][1],str(farminv.farminventory[0][i]),farminv.farminventory[1][i],farminv.farminventory[2][i])
				"recipe":
					cookslots[i].cslotupdate(invenitem[farminv.farminventory[1][i]][0],str(farminv.farminventory[0][i]),farminv.farminventory[1][i],farminv.farminventory[2][i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#####step 1 add ingrident to ingrident slot
### also make sure if there is any duplicate and keep track of it
func on_cookslot_focus(ingregion,ingamount,ingname,ingtype,posInfarmslot):
	var haveenoughinslot=0
	for i in range(ingredientslots.size()):
		if ingredientslots[i].texture_normal.resource_name=="empty_slot":
			for j in range(ingredientslots.size()): ### look all 4 to see how many of the we got and then make sure that number is less then amount we have!!! or else we dont have enough ingredient
				if ingredientslots[j].checkingname()==ingname:
					haveenoughinslot+=1
			if int(ingamount)>haveenoughinslot: ## checking if we put same item in diff slot we have enough!!!
				ingredientslots[i].addingredient(ingregion,ingamount,ingname,ingtype,posInfarmslot,haveenoughinslot)
				break
			else:
				print("out of ingredient")
			
	pass # Replace with function body.


##### stat and stop cooking-check if ingrident slot has item! if so it cook , if cooking and we stop it will finish yield instantly and stop the timer

func _on_Button_pressed():
	if cookingbutton.text=="Stop Cooking":
		cookingbutton.text="Start Cooking"
		if cook.is_valid():
			cook.resume() # can do resume(print("a")) now on yield it will print a instead of doing the timer# stop the yield timer!pretty much instantly finished the timer but the if ..=" stop cooking" will prevent from sucessfully cooking!!!!!
	##probelm is that timer in that yield will still execute and give us error so we have to get rid of that by saving it in diff var and change that var
			timer.unreference()
			timer=null
	elif cookingbutton.text=="Start Cooking":
		##aka start cooking# check if all 4 slot has ingredient!!! and then determine what to cook!!!
		for i in range(ingredientslots.size()):
			if ingredientslots[i].texture_normal.resource_name=="empty_slot":
				break
			elif i== ingredientslots.size()-1: # all 4 slot has ingredient!! 
				############ just have to loop this again!!! until keepcooking returns "cant cook" or just check if cookingbutton.text="Start Cooking" this means cant cook no more
				cookingbutton.text="Stop Cooking"
				#### if i want to cook on every click then i can just change text to Start Cooking
#				finishcooking()
#				startcooking()
		##### just have to check what the result of current ingrident!! and then input the timer for it to get done cooking!!!!
				cook=keepcooking(5)
	pass # Replace with function body.
	
	
# time it takes for cooking to be done!!!!
##first it check if ingrident slot still has item
##if so it finishes cooking (aslong as cooking wasnt stoped!)and then start cooking again
func keepcooking(cookingtime):

	while cookingbutton.text=="Stop Cooking": # keep looping the cooking
		timer=get_tree().create_timer(cookingtime) # keep reference to timer
		yield(timer,"timeout")
		### reason we check after yield cuz in case they took out mat at end of timer only prob is !! it changes at end of timer
		for i in range(ingredientslots.size()):
			###solved by creating empty ingrident slot signal which will instantly finish but start cooking will change to stop cooking so nothing will cook# problem if player take out mat and replaces it before time run out!! then it will not do missing instead it will still cook with that new ingrident but meh!!
			if ingredientslots[i].texture_normal.resource_name=="empty_slot":
				cookingbutton.text="Start Cooking"
				print("missing Ingredient")
				break
			elif i== ingredientslots.size()-1: # all 4 slot has ingredient!! 
				#cookingbutton.text=cookingbutton.text
				if cookingbutton.text=="Stop Cooking": ## in case they stop cooking and also resume() insta field but this will prevent from sucessfully cooking!! #canceling the timer!!
					finishcooking()
					startcooking()
		#print("test") #just testing if resume() will instantly do yield or wah

#### just updates ingrident slot!!!! aslong as same inventory slot hasthe item !!!!
func startcooking(): ## make sure there is still enough item in slot
	### update amount on all ingredient!!!
	var sameingredient=0
	for i in range(ingredientslots.size()):
		if int(cookslots[ingredientslots[i].slotposition].returncamount())>ingredientslots[i].haveduplicate and cookslots[ingredientslots[i].slotposition].farmitem==ingredientslots[i].inamelabel.text : # amount in cooking slot is more then current and its same item !! in case somethign else is added to that slot
			ingredientslots[i].changeingredientamount(cookslots[ingredientslots[i].slotposition].returncamount())
		else: # this means not enough amount stop cooking!!! 
			cookingbutton.text="Start Cooking" # change text so player can add new ingredient to start cooking again
			print("not enough ingredient")
			ingredientslots[i].addingredient(Rect2(Vector2.ZERO,Vector2.ZERO),0,"Ingrident","empty","none",0)
			### can just do return cant cook  or cooking=false 
		
		pass
func finishcooking(): # remove item from slot!!!
	cooking="happening"
	if ShopFarmslot!=null:# shop node
		for i in range(ingredientslots.size()):
			ShopFarmslot.removefromInv(ingredientslots[i].slotposition,1)
			### just have to add to inventory!!!!
		## dictionay.has_all(array) !! check if dictionary has all the key in array !! then we can check amount!
		var ingridentsss=[ingredientslots[0].checkingname(),ingredientslots[1].checkingname(),ingredientslots[2].checkingname(),ingredientslots[3].checkingname()]
		var ingridentss=[] ## will only store unique ingrident aka value thats not a duplicate 
		for i in ingridentsss:
			ingridentss.append(i)###add element!!!
			if ingridentss.count(i)>1: ## check if recent added element exist more then once in this new array if it so then we remove that element( since its the last added elemnt we remove from the back) 
				ingridentss.pop_back()
		
		for i in range(recipes.size()):## make ingridentss and recpies has all elemnt and they are same 
			if recipes[i].has_all(ingridentss) and recipes[i].keys().size()==ingridentss.size():#recipe and ingrident must be same size and have same elemnt if not same size then ingrident could only have 1 element in the recpie and it would return true hence why we do ingrident array with no duplicate!!!!!!# return true aslong as it has_all the given ingrident in array ex dictornary could have 2 key and array could only have 1 element it will return true cuz diconary has all element in that array even tho array dont have that 2nd key
				#
				#print(recipes[i].has_all(ingridentss), recipes[i],ingridentss)
				if cooknotification==true:
					dialogtext.visible=true
				dialogtext.dialog_text="able to cook:"+ recipesname[i][0] #+ " path is "+ recipesname[i][1]
				if recipesname[i][1]=="recipe":
					var invspace=ShopFarmslot.addtoinv(recipesname[i][0],1)#name,amount
					if invspace==false: ### not enough space in inventory!! but it will still remove iten from inventory cuz cooking was done!!!
						cookingbutton.text="Start Cooking"
						dialogtext.dialog_text="able to cook:"+ recipesname[i][0] +" but ran out of space"
				if recipesname[i][1]=="food":
					var inventspace
					inventspace=inventoryslot.addfood(1,recipesname[i][0],recipesname[i][2])# stun or "Hp",10, Hp heal)# name used to find item_type and item_type is used from stoping from upgrade since diff weapon type and i did  it on else
					if inventspace==false: ### not enough space in inventory!! but it will still remove iten from inventory cuz cooking was done!!!
						cookingbutton.text="Start Cooking"
						dialogtext.dialog_text="able to cook:"+ recipesname[i][0] +" but ran out of space"
				cooking="nothappening"
				return
			elif i==recipes.size()-1:
				if cooknotification==true:
					dialogtext.visible=true
				dialogtext.dialog_text=("cooking fail no recipe")
	cooking="nothappening"

func on_ingredient_focus():
	if cookingbutton.text=="Stop Cooking":
		cookingbutton.text="Start Cooking"
		if cook.is_valid():
			cook.resume() # can do resume(print("a")) now on yield it will print a instead of doing the timer# stop the yield timer!pretty much instantly finished the timer but the if ..=" stop cooking" will prevent from sucessfully cooking last 3rd line in keepcooking()!!!!!
			timer.unreference()
			timer=null



func _on_CheckBox_toggled(button_pressed):
	cooknotification=button_pressed
