extends Node2D
#item data + generate item  to drop
#send signal and inventory array anytime item is added/removed from the inventory array 
#var inventory=[]
var b= 0
var a=Vector2.ZERO  #track elemennt in loop table for item to drop
var inventoryempty=false
onready var farminventory=get_tree().get_root().get_child(0).get_node("inventory/CenterContainer_inv/TabContainer/farm/farm/ScrollContainer/CenterContainer/SHOP")
###spec-4,sword-4,axe-4,staf-4,helm-8,armor-5,leg-5,boot-5
### need to make accesory and potion


######dont need this going to combine!!!!
#var drop_list={"rat":{1:
#	{"normal_drop":["helm","armor","leg","shoe","sword"]  , #"sword","axe","gold","helm","armor","leg","shoe"
#	"rare_drop":["gold","gold","gold","helm","shoe"]}, #"sword","sword1","axe","sword3","gold"
#	2:
#	{"normal_drop":["helm","armor","leg","shoe","sword"], 
#	"rare_drop":["gold","gold","gold","helm","shoe"]},
#	4:
#	{"normal_drop":["helm","armor","leg","shoe","sword"], 
#	"rare_drop":["gold","gold","gold","helm","shoe"]}
#	}
#	#new enemy:{lvl:{normal:drop, rare:drop}, lvl:{drop} }
#	} ### i did this sep so i can make a mob drop one item more then other!!!
############################
	
var c=0 #inventory check track for item stats
##### how to grab from dictionary using variable from function
#### instead of this just make dict with item name and stat !!! that way all i have to do is mulitply ea stat with level or something!!! currrently its redundently to create same item with same ratio stat under diff enemyy name...
## gold on normal drop, metal on rare!!!
#var mob={1:
#			{"rat":
#					{"normal_drop":["helm","armor","leg","shoe","sword"],
#					"rare_drop":["gold","gold","gold","metal","helm","leg"],
#					"shoe":["hp",30,10,"defprot",3,1], # hp chance = 30+10 to 10 and def 3+1 to 1
#					"helm":["hp",20,12,"def",1,1] }, # 22 to 12 and 2 to 1 
#			"skeleton":
#					{"sword":[10,1,3,4],
#					"axe":["hp",24,5,"str",4,2],
#					"helm":[1,1,1,1] }},
#		2:
#			{"rat":
#					{"normal_drop":["gold","gold","leg","shoe","gold","gold"],
#					"rare_drop":["gold","gold","gold","metal","armor","shoe"],
#					"leg":["hp",35,18,"defprot",4,1], # hp10-1,atk3-4 etc
#					"armor":["hp",50,24,"defprot",3,1]},
#			"skeleton":
#					{"normal_drop":["gold","gold","leg","shoe","gold"],
#					"rare_drop":["gold","gold","gold","leg","armor"],
#					"leg":["def",2,1,"hp",70,30], # hp10-1,atk3-4 etc
#					"armor":["def",3,2,"hp",100,40] }},
#					} # sword will only have atk, hp maybe so first 2 number are max and min atk, 2nd is max and min hp

### mob keep track of drop and stat of specific enemy at specific level
## if we dont have in mob then it check if item stat exist in item stat
####itemstat jsut store stat using its name!!! if name dont exist even there
### drop item with default stat aka just base atk on sword, hp and defprot on gear!!!!

#### mob , lvl, mobname, drops and drop stat% (stat will auto base on lvl but we can controll stat it gives!!
# ex lvl one gives 4 stat  
## upgrade will only inc hp on non weapon gear and base atk on weapon so weapon must have baseatk and rest need to have hp
## only add here if i am going to write their specific drop and that drops stat
#only every lvl 5-30 so best gear every 5-30 lvl and on rest default.. so i dont have to 1000+line for each level
var mob={1:
			{"rat":
					{"normal_drop":["helm","armor","leg","shoe","sword"],
					"rare_drop":["gold","gold","gold","metal","helm","shoe"],
					"shoe":["hp",.225,"defprot",1], 
					"helm":["hp",.125,"def",1] },
			"skeleton":
					{"sword":[10,1,3,4],
					"axe":["hp",1,"str",1],
					}},
		2:
			{"rat":
					{"normal_drop":["gold","gold","leg","shoe","gold","gold"],
					"rare_drop":["gold","gold","gold","metal","armor","leg"],
					"leg":["hp",.25,"defprot",1],
					"armor":["hp",0.4,"defprot",1]},
			"skeleton":
					{"normal_drop":["gold","gold","leg","shoe","gold"],
					"rare_drop":["gold","gold","gold","leg","armor"],
					"leg":["def",.25,1,"hp",.4],
					"armor":["def",.4,2,"hp",0.4] }},
		3:
			{"rat":
					{"normal_drop":["helm","armor","leg","shoe","sword"],
					"rare_drop":["gold","gold","gold","metal","sword","sword"],
					"sword":["level",3,"baseatk",1,"str",1]}},
		4:
			{"rat":
					{"normal_drop":["helm","armor","leg","shoe","sword"],
					"rare_drop":["gold","gold","gold","metal","helm","shoe"],
					"sword":["baseatk",1,"str",1],
					"sword1":["baseatk",1,"str",1],
					"shoe":["hp",.225,"def",2],
					"armor":["hp",0.4,"def",2],
					"leg":["hp",.25,"def",4],
					"axe":["baseatk",1,"str",6],
					"helm":["hp",.25,"def",2]}},
		5:
			{"rat":
					{"normal_drop":["helm","armor","leg","shoe","sword"],
					"rare_drop":["gold","gold","gold","sword","axe"],
					"sword":["baseatk",1,"str",1],
					"axe":["baseatk",1,"str",1]}},
		6:
			{"rat":
					{"rare_drop":["gold","gold","gold","sword1","axe1"],
					"sword":["hp",.12,"str",1,"baseatk",1],
					"sword1":["hp",.12,"str",1,"baseatk",1],
					"shoe1":["hp",.225,"def",1],
					"armor1":["hp",.4,"def",2],
					"leg1":["hp",.25,"def",1],
					"axe1":["hp",.1,"str",1],
					"helm":["hp",.125,"def",1]}}
					} # sword will only have atk, hp maybe so first 2 number are max and min atk, 2nd is max and min hp

#########default level itemstat based on drop and default level monster drop 
# for gear dont have to worry about defprot or hp(rare also drop def so dont need to add def either or keep it super low) as it will auto do it!!!
# for weapon dont have to mention baseatk!! just other stat!
var itemstat={"armor1":["wisdom",.05],#no effect if less then 50#since it give percent of stat we want close to .05 or less#after lvl 50 gives 50+level*__ number from array 
				"helm1":["wisdom",.03],
				"sword1":["str",.01],
				"shoe1":["wisdom",.03],
				"leg1":["wisdom",.03],
				"axe":["crit",.03]
			}
var defaultdrop={"rat":["helm","armor","leg","shoe","sword","gold","gold","gold","gold","gold"],
	"rat1":["helm1","armor1","leg1","shoe1","gold","gold","gold","gold","gold"], # rat1= lvl 10+
	"rat2":["gold","gold","leg1","shoe1","sword1","axe1","gold","gold","gold","gold","gold"], # rat1= lvl 10+
	"default":["helm","armor","leg","shoe","sword","gold","gold","gold","gold","gold","gold","gold","gold"]
	}
signal inventory_update(inventory)
### can manually do mob= {level:{mob:{item:{[posible stat]}}}, next lvl {mob{..{..}}}} or i could just multiply/use function to increa ea stat by level!
func gold_drop(elevel):
	var goldDrop=round(.0018*pow(elevel,2)+8.8*elevel+36) # was at 6 instead of 36 just rased base so get more earlyon
	return goldDrop
func generate_stats(level,enemy,item_name,rarity):
#	if rarity=="rare":
#		var stat1 # used to calculate ea stat
#		var stat :Array # store all stat#or can do stat=[]
#		if item_name=="gold": # for  gold drop item name=gold and for stat we will just do amount being dropped!! rare drop 10% extra... gold
#			stat=[1.10*gold_drop(level)]
#			pass
#		else:
#			for i in mob.get(level).get(enemy).get(item_name).size()-1: # rare use all 4 stat, common only give 1 stat bonus  so instead of -1 we do bigger nubmer so only get first stat instead of all
#				if i%3==0:
#					stat1 =randi()%mob.get(level).get(enemy).get(item_name)[i+1]+mob.get(level).get(enemy).get(item_name)[i+2]
#					#stat=[mob.get(level).get(enemy).get(item_name)[i],stat1] # reset every 3rd loop so wont save first 2 number
#					stat.append(mob.get(level).get(enemy).get(item_name)[i])
#					stat.append(stat1)
#					### stat 2 and etc just # to list and then here!!! on other rarity just do stat 1 then next lvl stat 1 and (stat 2)/2
	####in case i didnt create stat for any item with number ex armor1#this will just add that number to end 
	var gearname="none"
	var weaponname="none"
	if int(item_name)>0: # checking if it has any number
		var itemnumber=item_name
		itemnumber.erase(itemnumber.find(int(itemnumber)),10) # erase the number and see what type of gear it is
		if itemnumber=="armor" or itemnumber=="leg" or itemnumber=="helm" or itemnumber=="shoe":
			gearname=item_name
		else:
			weaponname=item_name 
	##### checking if i created the stat for weapon
	var hasitemstat="donthave"
	if mob.has(level) and mob.get(level).has(enemy):
		hasitemstat=item_name
	var stat1
	var stat:Array
	var gear={"armor":0.4,"armor1":0.4,"armor2":0.4,"armor3":0.4,"armor4":0.4,
	"helm":.125,"helm1":.125,"helm2":.125,"helm3":.125,"helm4":.125,"helm5":.125,
	"helm6":.125,"helm7":.125,"helm8":.125,"leg":.25,"leg1":.25,"leg2":.25,"leg3":.25,
	"leg4":.25,"shoe":.225,"shoe1":.225,"shoe2":.225,"shoe3":.225,"shoe4":.225}#going to define in item stat array! so every item has its unique stat#stat1 =(randi()%int(2*level+level*log(level+1)*10*.70*gear[item_name]))+int(2*level+level*log(level+1)*10*.60*gear[item_name])

	#### just need item_name and lvl to create stat # using for lvl whose item not implemented or simply for item that stat isnt specified yet
	match item_name:
		"metal":
			stat=[1]
		"gold":
			stat=[1.10*gold_drop(level)]
		hasitemstat: #specific level and specific name# if it has stat
			stat.append("level")
			stat.append(level)
			stat.append("Cost")
			stat.append(gold_drop(level))
			stat.append("M Cost")
			stat.append(0)   
			stat.append("Value")
			stat.append(round(gold_drop(level)*2))
			stat=stat+statupgrade(level,enemy,item_name,rarity)
		
		"armor","helm","leg","shoe",gearname: # default if stat not made# in case stat not created..., gearname are gear with numberin end like helm1,helm2, armor1(we already check above what type of gear it is)
			stat.append("level")
			stat.append(level)
			stat.append("Cost")
			stat.append(round(gold_drop(level)*.3)) ### need to fix cuz it depend on item type !!!
			stat.append("M Cost")
			stat.append(0)
			stat1 =(randi()%int(ceil((2*level+level*log(level+1)*10)*.70*gear[item_name])))+int((2*level+level*log(level+1)*10)*.60*gear[item_name])
			stat.append("Value")
			stat.append(round(gold_drop(level)*2))
			stat.append("Hp")
			stat.append(stat1)
			stat1=randi()%int(ceil(level*1*gear[item_name]+1))+int(level*gear[item_name]) # return from lvl to 2*lvl since(lvl*1+lvl= 2*lvl)
			stat.append("defprot")
			if stat1==0:
				stat1=1
			stat.append(stat1)
			if rarity=="rare":
				stat[9]=round(stat[9]*1.5) # hp
				stat[11]=round(stat[11]*1.5) #defprot
				stat[7]=round(stat[7]*2) # value
				stat.append("def")
				stat1=randi()%int(ceil(level*.25))+level*.25  # up to lvl*50%
				if stat1<=1:
					stat1=1
				elif stat1>=50:
					stat1=50+level*.05*.6+randi()%int(ceil(level*.05*.4)) #60% of the 5% def stat is given rest 40% from 5% is random  so max is 50+level*.05*1
				stat.append(round(stat1))
			if itemstat.has(item_name):
				for i in range(itemstat.get(item_name).size()):
					if i%2==0:
						stat.append(itemstat.get(item_name)[i])
					else:
						stat1=randi()%int(ceil(level*.25))+level*.25  # up to lvl*50%
						if stat1<=1:
							stat1=1
						elif stat1>=50:
							stat1=50+level*itemstat.get(item_name)[i]*.6+randi()%int(ceil(level*itemstat.get(item_name)[i]*.4))#.05 and *.6+rand becase 60% of .05 is garrunte rest 40%is random#should be close to .05
						stat.append(round(stat1))
		"sword","axe","staff",weaponname:
			stat.append("level")
			stat.append(level)
			stat.append("Cost")
			stat.append(gold_drop(level))
			stat.append("M Cost")
			stat.append(0)
			stat1=randi()%int(ceil(1+(-3.6+4.647*level+0.03465*pow(level,2))*.2))+int(ceil(1+(-3.6+4.647*level+0.03465*pow(level,2))*.5))#50-70%
			stat.append("Value")
			stat.append(round(gold_drop(level)*2))
			stat.append("baseatk")
			stat.append(stat1)
			if rarity=="rare":
				stat[9]=round(stat[9]*1.5) # baseatk
				stat[7]=round(stat[7]*2) # value
				#print(stat[6]," test ",stat[8])
	emit_signal("inventory_update",item_name,stat,rarity)
	#return  stat # or i can just do def*level^(1+(1/5))


#### generate stat using the array to find percent!!!
# so just check if item exist in array before you start!!!
# if mob.get(elevel).get(enemyname).has(item_name):
func statupgrade(elevel,enemyname,item_name,item_rarity):
	#find stat percent stat[stat.find("statname")+1]#(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("defprot")+1])
	var stats:Array
	var addstat
	var statpercent
	if mob.get(elevel).get(enemyname).get(item_name).has("hp"):
		addstat=(randi()%int(2*elevel+elevel*log(elevel+1)*10*.70*(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("hp")+1])))+int(2*elevel+elevel*log(elevel+1)*10*.60*(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("hp")+1]))
		stats.append("Hp")
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("defprot"):
		addstat=randi()%int(elevel*1*(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("defprot")+1])+1)+int(elevel*(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("defprot")+1]))
		#lvl*1*percent+1  + lvl*percent so we get 2*lvl*percent+1
		if addstat==0:
			addstat=1
		stats.append("defprot")
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("str"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("str")+1])
		stats.append("str")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("atk"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("atk")+1])
		stats.append("atk")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("wisdom"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("wisdom")+1])
		stats.append("wisdom")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("crit"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("crit")+1])
		stats.append("crit")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("luck"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("luck")+1])
		stats.append("luck")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("def"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("def")+1])
		stats.append("def")
		addstat=randi()%int(ceil(elevel*.25))+elevel*.25  # up to lvl*50% until 50 point then 5%/statpercent(60% given 40% random of the total 5%)
		if addstat<=1:
			addstat=1
		elif addstat>=50:
			addstat=50+elevel*statpercent*.6+randi()%int(ceil(statpercent*elevel*.4))
		stats.append(round(addstat))
	if mob.get(elevel).get(enemyname).get(item_name).has("baseatk"):
		statpercent=(mob.get(elevel).get(enemyname).get(item_name)[mob.get(elevel).get(enemyname).get(item_name).find("baseatk")+1])
		addstat=randi()%int(1+(-3.6+4.647*elevel+0.03465*pow(elevel,2))*.2)+int(1+(-3.6+4.647*elevel+0.03465*pow(elevel,2))*.5)
		stats.append("baseatk")
		stats.append(round(addstat*statpercent))
	return stats
func _ready():
#	# testing how to add/ remover number from string
#	var n="sword12"
#	if int(n)>0:
#		print(n+str(int(n))) # add number to string
#		print(n.erase(n.find(int(n)),10),n) # erase number from string, make sure to do find (int(n))>0 in case it has no number
#	else:
#		print(n)
	### jsut make sure dictionary has is working right
#	if mob.get(1).get("rat").has("sword"):
#		print("it has the item stat percent array")
#	else:
#		print("it dont got item so use lvl to generate stat")
### testing stat create func for item in dictonary drop
#	statupgrade(1,"rat","shoe","rare")
	
	
	#emit_signal("inventory_update","axe",["level",1,"Cost",10,"M Cost",0,"Value",10,"baseatk",1],"normal")
#	for i in 200:
#		print(randi()%int(2*level+level*log(level+1)*10*.70*.125)+int(2*level+level*log(level+1)*10*.55*.125))
	#print(generate_stats(1,"rat","sword"))
	pass

##########do inventory in inventory
#func append(item):
#	inventory.append(item)
#	emit_signal("inventory_update",inventory) 
#func remove(item):
#	inventory.remove(item)
#	emit_signal("inventory_update",inventory)
#func stat_generate(rarity,item_name):
#	var hp
#	var armor
#	var matk
#	var def
#	var atk
#	if "rarity"=="normal_drop":
#		match "item_name":
#			"helm":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				armor=randi()% 3+1
#				pass
#			"armor":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				armor=randi()% 3+1
#				pass
#			"shield":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				armor=randi()% 3+1
#				pass
#			"sword":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				atk=randi()% 3+1
#				pass
#			"staff":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				matk=randi()% 3+1
#				pass
#			"axe":
#				randomize()
#				hp=randi()% 10+5     #"max_hp"+"min_hp"
#				atk=randi()% 3+1
#				pass
#
#	if "rarety"=="rare":
#		pass
#	if "rarety"=="epic":
#		pass
#	return hp and armor and atk and def
	
	
#	match[rarity,item_name]:
#		[rarity,"helm"]:
#			for i in range(4):# range(total type of  rarity)
#				if rarity==normal:
#					randomize()
#					var hp=randi()% 10+5     #"max_hp"+"min_hp"
#					var armor=randi()% 3+1
#				elif rarity==epic

		

	
#func item_generate(rarity,item_name):  ## change to item genrate
#	(get_tree().get_root().get_node("level/player").combat_power)
#	for i in 10: #10= level i have created
#		if (get_tree().get_root().get_node("level").level)==i: # grabs level variable from level node
#				  # use i to come up with function to increase stats ex armor*i^(i+(1/5))
#			#if (get_tree().get_root().get_node("level/player").combat_power)< 100: # extra dont really need# write down combat power limit for level 1
#			pass
#
#	match item_name:
#		"helm":
#			get_parent().level

	#emit_signal("inventory_update",item_name)
	
	# for name in inventory slot:  checking if the item exist in inventory if it does then 
	# 	min_stat=...  get number from inventory and map level
	#	if inventory stat-10< map level max stat
	#    	min_stats= inventorystat
	#       max stats = map max stat
	#   elif inventory stat-10> map level max stat  check if current item better
	#       minstat= map max stat-10
	#       max stat= map max sstat
	# or i could just use cp to keep track and it be easeier and less power to figure
	
	
#	for i in inventory : # change this to inventory check
#		c+=1 # tracking for last match!!!
#		if i=="empty": #checking if we have any empty slot #### dont need to for item match but for inventory function test###
#			print("has empty space")
#			inventoryempty=true
#		if i==name:  #checking if item in inventorory
#			c=0
#			print("inventory has item")
#			break # stop for loop dont have to go below loop
#		elif c==inventory.size() and inventoryempty==true:
#			c=0
#			print ("item not in inventory and can add") # item not in inventory
#			inventoryempty=false
#
		 
	#have to create item slot nd see how to acces it and yah add in for loop to compare
	
	
	
#drop test
#randomize random numer 
#randi()%100+1 generate number
#if number >99  1/99 chance
#   shuffle rare drop then drop item from array [a] at ath position a just variale to keep track of which element from drop list to drop
#   a+=1 drop item at a element then add 1 to it
#       if a= length of drop list length
#            a=0 reset a
#intoduce random stat for item!!! just gona make function that keeps track of item in inventory and use those stat to create random stats
# add the fnction on drop so it drop the item with that stats
#func need to the name of the so thats one variale we must have stats genrate("array[a])
#####################################################
#func _physics_process(delta):
#	if Input.is_action_pressed("ui_right"):  #signal enemy died
#		randomize() #randomize every kill so u have 10%=1/10(maybe get 1  in 10 kill) chance of getting item and if not randomise 10% drop(only randomise once!! now u gaurante to get 1 every 10)! aka 
#		b=randi() %100+1 # genrate number 1-100 but if %100 then 0-99
#		print(b)
#		if b>99 : #rare 1/100 chace
#			drop_list.mob_a.rare_drop.shuffle()# randomize rare drop
#			stat_generate(drop_list.mob_a.rare_drop[a.y]) # item stat
#			print(drop_list.mob_a.rare_drop[a.y]) #want this before u do +1 so can drop 0 element
#			a.y +=1 #track element to drop from array
#			if a.y ==drop_list.mob_a.rare_drop.size():
#				a.y=0 #reset count so it dont exceed array size
#		elif b>95: # 5/100=1/20 chance 
#			pass
####################### testing how to randomly drop an item if item exist then use those state to genrate item



func _on_spawndeath_track_dropitem(e_lvl,e_name):  # drop item!!!! #### signal must give enemy name!! then we get map level then we randomly pick item_name
	randomize()
	b=randi() %100+1
	if b<70 : #rare 1/100 chace
		pickdrop(e_name,e_lvl,"rare")
	elif b<100:
		farminventory.addtoinv("sand",1)
	
##	defaultdrop["rat"].shuffle()
##	#####################for test purpose, check for item i created so far and making sure it don go beyond this lvl
##	if e_lvl>5:
##		e_lvl=5
#	#print(get_tree().get_root().get_node("level").level) ### map level 
#	#print("droped")
#	randomize()
#	b=randi() %100+1
#	### can do 5% b<=5 for rare,10% b<=15, 25% b<=40,50% b<=90, else or 10% b<=100 drop farm item now select drop from diff list!!! bam
#	###print(b)
#	if b>5 : #rare 1/100 chace
#		pickdrop(e_name,e_lvl,"rare")
##		if mob.has(e_lvl):
##			mob[e_lvl][e_name].rare_drop.shuffle()# randomize rare drop
##			generate_stats(e_lvl,e_name,mob[e_lvl][e_name].rare_drop[0],"rare") # did 0 isntead of a.y ## for test purpose gona use lvl 1 isntead of ^ e_lvl
##		else:
##			generate_stats(e_lvl,e_name,defaultdrop["rat"][0],"rare")
#
#
##		mob[e_lvl][e_name].rare_drop.shuffle()# randomize rare drop
##		print(a.y," must be ",mob[e_lvl][e_name].rare_drop[a.y])
#		#####generate_stats(e_lvl,e_name,drop_list.mob_a.rare_drop[a.y],"rare")
#		##############have to check if enemy drop list made if not
#
##			generate_stats(e_lvl,e_name,mob[e_lvl][e_name].rare_drop[0],"rare") # did 0 isntead of a.y ## for test purpose gona use lvl 1 isntead of ^ e_lvl
#		#item_generate("rare",drop_list.mob_a.rare_drop[a.y]) # item stat need this before append so it dont check it self in inventory!!!
#		#print(append(drop_list.mob_a.rare_drop[a.y])) #want this before u do +1 so can drop 0 element(a= vector2 and a.y is variable i am using to make sure we dont go past the length of the raredrop array
#		######## dont need to do this spec if i do random size drop pool on each enemy 
#
##		a.y +=1 #track element to drop from array  (need to have bigger vector so each x,y,z is connected to rare,common,uncommon drop to keep trach of arry length!!
##		#print(inventory)
##		if a.y ==mob[e_lvl][e_name].rare_drop.size():# -1 because array size 5 has 5 element but it starts with 0 not 1!! hence we need -1
##			a.y=0 #reset count so it dont exceed array size
#	elif b>95: # 5/100=1/20 chance 
#		pass		
func pickdrop(enemy_name,enemy_level,rareness):# drop with specific lvl and name aka mob table
	if mob.has(enemy_level) and mob[enemy_level].has(enemy_name):
		mob[enemy_level][enemy_name][rareness+"_drop"].shuffle()
		generate_stats(enemy_level,enemy_name,mob[enemy_level][enemy_name].rare_drop[0],rareness)
	else: # default drop!!!
		if defaultdrop.has(enemy_name): ###if enemy drop table exist
			if rareness=="rare":
				defaultdrop[enemy_name].append("metal")
			defaultdrop[enemy_name].shuffle()
			generate_stats(enemy_level,enemy_name,defaultdrop[enemy_name][0],rareness)
			if rareness=="rare":
				defaultdrop[enemy_name].remove(defaultdrop[enemy_name].find("metal"))
		else:## if not default drop
			defaultdrop["default"].shuffle()
			if rareness=="rare":
				defaultdrop["default"].append("metal")
			generate_stats(enemy_level,enemy_name,defaultdrop["default"][0],rareness)
			if rareness=="rare":
				defaultdrop[enemy_name].remove(defaultdrop[enemy_name].find("metal"))
