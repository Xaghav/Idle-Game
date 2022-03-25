extends Node2D
onready var statlabel=get_tree().get_nodes_in_group("statlabeltest")
onready var lvllabel=$Label3
onready var elvllabel=$Label
onready var combat=preload("res://resource/game/combat.tres")
var amount=1
onready var amountlabel=get_node("HBoxContainer/Label")
var lvl=1
var elvl=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	##1.275 @10000
	var level=1000
	print(int((2*level+level*log(level+1)*10)*.70)+int((2*level+level*log(level+1)*10)*.60)," ",round(level*2+(level)*log(level)*10)*1.2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed(extra_arg_0):
	match extra_arg_0:
		"str":
			statlabel[0].text=str(int(statlabel[0].text)+amount)
		"atk":
			statlabel[1].text=str(int(statlabel[1].text)+amount)
		"def":
			statlabel[2].text=str(int(statlabel[2].text)+amount)
		"defprot":
			statlabel[3].text=str(int(statlabel[3].text)+amount)
		"crit":
			statlabel[4].text=str(int(statlabel[4].text)+amount)
		"luck":
			statlabel[5].text=str(int(statlabel[5].text)+amount)
		"basehp":
			statlabel[6].text=str(int(statlabel[6].text)+amount)
		"hp":
			#based on def#statlabel[7].text=str(int(statlabel[7].text)+amount)
			pass
		"basedmg":
			statlabel[8].text=str(int(statlabel[8].text)+amount)
		"estr":
			statlabel[9].text=str(int(statlabel[9].text)+amount)
		"eatk":
			statlabel[10].text=str(int(statlabel[10].text)+amount)
		"edef":
			statlabel[11].text=str(int(statlabel[11].text)+amount)
		"edefprot":
			pass
			#statlabel[12].text=str(int(statlabel[12].text)+amount)
		"ecrit":
			statlabel[13].text=str(int(statlabel[13].text)+amount)
		"eluck":
			statlabel[14].text=str(int(statlabel[14].text)+amount)
		"ebasehp":
			pass
			#statlabel[15].text=str(int(statlabel[15].text)+amount)
		"ehp":
			pass
			### dont need
			#statlabel[16].text=str(int(statlabel[16].text)+amount)
		"ebasedmg":
			pass
			#statlabel[17].text=str(int(statlabel[17].text)+amount)
	### enemy and player hp based on lvl and def
	lvl=(int(statlabel[0].text)+int(statlabel[1].text)+int(statlabel[2].text)+int(statlabel[4].text)+int(statlabel[5].text)-1)/4
	lvllabel.text=str(lvl)
	elvl=(int(statlabel[9].text)+int(statlabel[10].text)+int(statlabel[11].text)+int(statlabel[13].text)+int(statlabel[14].text)-1)/4
	elvllabel.text=str(elvl)
	### auto does hp in other script so no need 
	## just for visual purpose
	statlabel[16].text=str(int((float((8*(int(statlabel[11].text)*.5+2*elvl))+0.035*pow(int(statlabel[11].text)*.5+2*elvl,2.1))*2 )))
	statlabel[7].text=str(int((float((8*(int(statlabel[2].text)*.5+2*lvl))+0.035*pow(int(statlabel[2].text)*.5+2*lvl,2.1))*2 )))
	#### base hp and base atk bonus,def prot for enemy
	var e_lvl_mob=elvl
	statlabel[12].text=str(e_lvl_mob*1) #prot
	statlabel[15].text=str(round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3)) #hp
	# atk
	statlabel[17].text=str(int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6)) 
########## maybe also add base hp,atk def prot bonus for player
	e_lvl_mob=lvl
	statlabel[3].text=str(e_lvl_mob*1)
	statlabel[6].text=str(round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3))
	statlabel[8].text=str(int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
func _on_Button1_pressed(extra_arg_0):
	match extra_arg_0:
		"1":
			amount=1
		"10":
			amount=10
		"100":
			amount=100
		"sign":
			amount*=-1
	amountlabel.text=str(amount)


#####fix baseatk and base hp for enemy to test!!!!
func _on_Button2_pressed():
	#combat.damage("2hsword",152,304,153,1,1,1,1,241,193,0,)
	var victory=0
	var matches=1
	var a =1000 ### after 850, 300 def means less cuz 300 point gives 60% more atk vs 300def will only reduce 41(.59*dmg)
#	print((8*400+0.035*pow(400,2))*4)
	print(statlabel[15].text)
	for i in matches:
		if combat.testfight(int(statlabel[6].text),"2hsword",1000,lvl,int(statlabel[1].text),int(statlabel[0].text),int(statlabel[4].text),int(statlabel[5].text),int(statlabel[2].text),int(statlabel[3].text),int(statlabel[8].text),int(statlabel[15].text),"2hsword",1000,elvl,int(statlabel[10].text),int(statlabel[9].text),int(statlabel[13].text),int(statlabel[14].text),int(statlabel[11].text),int(statlabel[12].text),int(statlabel[17].text))=="playerwon":
#		#testfight(php,pweapon,pj,plvl,pstat1,pstat2,pstat3,pstat4,pstat5,ehp,eweapon,ej,elvl,estat1,estat2,estat3,estat4,estat5):
#		#3=crit,4=luck

			print("playerwon")
			victory+=1
		else:
			print("playerlost")
			pass
	yield(get_tree().create_timer(1.6),"timeout")
	print("won:  ",victory," out of  ",matches, "  and lost ", matches-victory)
#(hp,weapon,j,lvl,atk,str,crit,luck,def,defprot,baseatk)
#	combat.testfight(int(statlabel[8].text)+int(statlabel[7].text),"2hsword",1000,lvl,int(statlabel[1].text),int(statlabel[0].text),int(statlabel[4].text),int(statlabel[5].text),int(statlabel[2].text),int(statlabel[3].text),int(statlabel[8].text),int(statlabel[15].text)+int(statlabel[16].text),"2hsword",1000,elvl,int(statlabel[10].text),int(statlabel[9].text),int(statlabel[13].text),int(statlabel[14].text),int(statlabel[11].text),int(statlabel[12].text),int(statlabel[17].text))
