extends Node2D
###just save level and current enemy spawn aka chance instead (save inital chance in file as random if i want to do that)of defining chance in spawn func use it as argument we so can spawn specific enemy
var enemy1=preload("res://resource/game/enemy.tscn")
var enemy2=preload("res://resource/game/enemy2.tscn")
enum estats{lvl,def,defprot}
var e_name="rat"
var e_lvl_mob=1
#onready var maps=get_node("../Popup/Map") #using signal instead
var currentch=1
#var playerdamage=1
#var enemydamage=1
#onready var player=get_node("../player")
signal dropitem()
signal expgain
#signal enemydamage()

func _ready(): 
	print(log(10)," log")
	#playerdamage=player.get_damage()
	spawn()
	#get_node("enemy").connect("death",self,"_on_enemy_death") # only will spawn 1 cuz 2nd spawn will have diff connect signal!!!
	
func update_estat(elvl,edef,edefprot):
	estats.lvl=elvl
	estats.def=edef
	estats.defprot=edefprot
	
func spawn():
	#currentch=maps.currentchapter #using signal instead
	
	#var enemy=preload("res://resource/game/enemy.tscn")
	randomize()
	var chance=randi()%5+1
#### finding level total 6 lvl spawn!!! 3 below low and 1 same and 2 above lvl !!!
	var e_lvl_chance=randi()%6+1
	e_lvl_mob=((currentch-1)*3)+e_lvl_chance-3 #so now elvlchance give chance of getting enemy 3lvl up and 3 lvl down ex at ch2-lvl posible 1,2,3,4,5,6# jsut cant do lvl 1 cuz then we will get -2,-1,0,1,2,3
#####spawn low lvl ch1: for ch 1 mob so if get 0,-1,-2 then mulitply by -1 so we get 3x lvl 1 ,2x lvl 2 chance and 1x lvl 3
	if e_lvl_mob<1:
		e_lvl_mob*=-1
		if e_lvl_mob==0:
			e_lvl_mob=1
###########
##picking enemy
	var enemysel=selectenemy(currentch,chance)
	print(chance)
	e_name=enemysel[0] # enemysel[0]= name for drop ex rat, enemysel[1]= instance type ex enemy1 will spawn rat, enemy2 will spawn dragon 
#####################test
#	if currentch==1:
#		print(chance)
#		e_lvl_mob=1
##		createenemy(e_lvl_mob,1+e_lvl_mob*2.42,1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
#		if chance<3:
#			e_name="rat"
#			#ideal---redo
#			createenemy(e_lvl_mob,1+e_lvl_mob*1.44,1+e_lvl_mob*1.10,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1+e_lvl_mob*.56,1+e_lvl_mob*.58,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
#			## testing stre*.42+crit*1
#			#createenemy(e_lvl_mob,1+e_lvl_mob*.42,1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1+e_lvl_mob*1,1+e_lvl_mob,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
#  #######normal better agains high  cuz crit will dec as enemy lvl up so smaller will do even less damage where str dmg will be same give or take!!!
#			#createenemy(e_lvl_mob,1+e_lvl_mob*2.42,1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
#		elif chance>2:
#			e_name="rat"
#			### stre*1 and crit *.42
#			createenemy(e_lvl_mob,1+e_lvl_mob,1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1+e_lvl_mob*.42,1+e_lvl_mob,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
####### just crit and luck ## good fighting lower lvl 
#			createenemy(e_lvl_mob,1,1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1+e_lvl_mob*1.42,1+e_lvl_mob,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
		#createenemy(e_lvl_mob,e_lvl_mob*2,e_lvl_mob,1,1,e_lvl_mob*1,e_lvl_mob*2,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1,1,1)
########################
#### to lower str (e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.005)))) and base atk (1-(1/(pow(e_lvl_mob,e_lvl_mob*.009)))) early game!!!
	if currentch<=1000:
		print(1+e_lvl_mob*2.42-(e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.005)))),"  ",1+e_lvl_mob*2.42)
#		e_lvl_mob=((currentch-1)*3)+e_lvl_chance #already done earlier#so now elvlchance give chance of getting enemy 3lvl up ex at ch2-lvl posible 4,5,6
		if chance==1:#full str # good for early game but - lvl*(1/( lvl^lvl*.005)) so weak early on but around 250 its 0ish and lvl 180 1% of lvl so 180*.01=1.8 not much
			createenemy(e_lvl_mob,1+e_lvl_mob*2.42-(e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.01)))),1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemysel[1],"2hsword",1,1,int((1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6)*(1-(1/(pow(e_lvl_mob,e_lvl_mob*.009))))))
		elif chance==2:#crit1,1, str.42# sub the least
			createenemy(e_lvl_mob,1+e_lvl_mob*.42-(e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.009)))),1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemysel[1],"2hsword",1+e_lvl_mob*1,1+e_lvl_mob,int((1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6)*(1-(1/(pow(e_lvl_mob,e_lvl_mob*.009))))))
		elif chance==3:#str1, crit.42,1# sub less
			createenemy(e_lvl_mob,1+e_lvl_mob-(e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.009)))),1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemysel[1],"2hsword",1+e_lvl_mob*.42,1+e_lvl_mob,int((1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6)*(1-(1/(pow(e_lvl_mob,e_lvl_mob*.009))))))
		elif chance>=4:# ideal:1.35,.52,.55# sub less like above
			createenemy(e_lvl_mob,1+e_lvl_mob*1.35-(e_lvl_mob*(1/(pow(e_lvl_mob,e_lvl_mob*.009)))),1+e_lvl_mob*1.26,1,1,1+e_lvl_mob*.32,e_lvl_mob*1,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemysel[1],"2hsword",1+e_lvl_mob*.52,1+e_lvl_mob*.55,int((1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6)*(1-(1/(pow(e_lvl_mob,e_lvl_mob*.009))))))
	
##################################old
#	if currentch==1:
#		### 1 and 4 gives hp so can beat 3 easily and 3 give 1 str weapon to beat 2## beating 3 chances are low with lvl 1!!!
#		# 1 easy,2beat most time,3 beat if lucky, 4 no chance till gear!!!
#		if chance==1:
#			e_name="rat"
#			#enemydamage=createenemy(1,1,1,1,10,playerdamage,enemy1) # no long need to do damage they directly get from atk signal in script
#			#######atk,strength,wisdom,def,e_hp,enemy,weapon,agi,crit,luck,elvl
#			createenemy(1,3,2,1,1,1,2,20,enemy1,"2hsword",1,1) # enemy of enemy1,and 2 i could put it in dictory with their level and call like that much easier
#			#update_estat(1,1,2) # elvl,edef,edefprot
#		elif chance==2:
#			e_name="rat"
#			#createenemy(5,8,1,5,1,2,12,90,enemy2,"1hsword",1,1)
#			createenemy(3,7,1,6,1,2,12,45,enemy2,"1hsword",1,1)
#			#update_estat(3,8,5)
#		elif chance==3:# spawn slower for some reason
#			e_name="rat"
#			createenemy(2,3,4,1,1,1,3,30,enemy2,"2hsword",1,1)# maybe move it down so player dont die on map 1 that much
#			#update_estat(5,6,12)
#		elif chance==4:#spawn slower for some reason
#			e_name="rat"
#			createenemy(3,2,1,3,1,1,2,25,enemy1,"1hsword",1,1)
#			#update_estat(2,1,5)
#	#		createenemy(1,30,1,1,130,enemy2,"1hsword",10,1,1,12)
#	#		update_estat(12,8,12)
#		elif chance==5:
#			e_name="rat"
#			createenemy(4,8,6,1,1,2,5,55,enemy2,"2hsword",1,1)
#	elif currentch==2: #5-10
#		if chance==1:
#			e_name="rat"
#			createenemy(4,4,8,1,1,2,20,200,enemy1,"2hsword",1,1)
#		elif chance==2:
#			e_name="rat"
#			createenemy(6,18,8,1,1,1,5,250,enemy2,"2hsword",1,1)
#		elif chance==3:
#			e_name="rat"
#			createenemy(5,13,1,9,1,1,20,230,enemy2,"1hsword",1,1)
#		elif chance==4:
#			e_name="rat"
#			createenemy(7,8,1,7,1,9,7,30,enemy1,"1hsword",1,1)
#		elif chance==5:
#			e_name="rat"
#			createenemy(4,4,10,6,1,4,6,35,enemy1,"1hsword",1,1)
#	elif currentch==3:
#		if chance==1:
#			e_name="rat"
#			createenemy(4,9,6,1,1,6,20,200,enemy1,"2hsword",1,1)
#		elif chance==2:
#			e_name="rat"
#			createenemy(6,14,8,1,1,5,5,350,enemy2,"2hsword",1,1)
#		elif chance==3:
#			e_name="rat"
#			createenemy(5,12,8,1,1,3,20,250,enemy2,"2hsword",1,1)
#		elif chance==4:
#			e_name="rat"
#			createenemy(4,10,1,6,1,1,6,120,enemy1,"1hsword",1,1)
#		elif chance==5:
#			createenemy(4,10,1,6,1,1,6,120,enemy1,"1hsword",1,1)

#	elif currentch<=10:
#		var e_lvl_mob=((currentch-1)*3)+1 # ch1 moblvl 1,2,3 then ch2 lvl 4,5,6 ### base hp is what i need hp on gear and stuff !!! # fyi basehp forumla grow slower it will eventually get outnumbered!!! 
#		#print(e_lvl_mob*log(e_lvl_mob)*20,"oo  ",e_lvl_mob,"  ", log(e_lvl_mob)) 
#		#### supose to have 1+ e_lvl... but didnt give so its easier!!
#		if chance==1: # lvl*4 *.25,.25 and .50 or 1,1,2
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob,e_lvl_mob*2,1,1,e_lvl_mob,e_lvl_mob*2,round((e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*15)*1.3),enemy1,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.6))
#			#print("hp",round(e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*20))
#		elif chance==2:
#			e_name="rat"
#			createenemy((e_lvl_mob+1),(e_lvl_mob+1),(e_lvl_mob+1)*2,1,1,e_lvl_mob+1,e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+1)*log(e_lvl_mob+1)*15),enemy2,"2hsword",1,1,1)
#		elif chance==3:
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob*0.85,1,e_lvl_mob*2,1,e_lvl_mob*1.15,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob*2)*log(e_lvl_mob+1)*15),enemy1,"1hsword",1,1,1)
#		elif chance==4 :
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob*1.5,e_lvl_mob*2.0,1,1,1+e_lvl_mob*0.5,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob+1.5)*log(e_lvl_mob+1)*15),enemy2,"2hsword",1,1,1)
#		elif chance==5 :
#			e_name="rat"
#			createenemy((e_lvl_mob+2),(e_lvl_mob+2),(e_lvl_mob+2)*2,1,1,(e_lvl_mob+2),e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+2)*log(e_lvl_mob+1)*15),enemy2,"2hsword",1,1,1)
#
#	elif currentch<=20:
#		var e_lvl_mob=((currentch-1)*3)+1 # ch1 moblvl 1,2,3 then ch2 lvl 4,5,6 ### base hp is what i need hp on gear and stuff !!! # fyi basehp forumla grow slower it will eventually get outnumbered!!! 
#		#### supose to have 1+ e_lvl... but didnt give so its easier!!
#		if chance==1: # lvl*4 *.25,.25 and .50 or 1,1,2
#			e_name="rat1"
#			createenemy(e_lvl_mob,e_lvl_mob,e_lvl_mob*2,1,1,e_lvl_mob,e_lvl_mob*2,round(e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*23),enemy1,"2hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.3))
#		elif chance==2:
#			e_name="rat1"
#			createenemy((e_lvl_mob+1),(e_lvl_mob+1),(e_lvl_mob+1)*2,1,1,e_lvl_mob+1,e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+1)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.3))
#		elif chance==3:
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob*0.85,1,e_lvl_mob*2,1,e_lvl_mob*1.15,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob*2)*log(e_lvl_mob+1)*23),enemy1,"1hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.2))
#		elif chance==4 :
#			e_name="rat2"
#			createenemy(e_lvl_mob,e_lvl_mob*1.5,e_lvl_mob*2.0,1,1,1+e_lvl_mob*0.5,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob+1.5)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.3))
#		elif chance==5 :
#			e_name="rat1"
#			createenemy((e_lvl_mob+2),(e_lvl_mob+2),(e_lvl_mob+2)*2,1,1,(e_lvl_mob+2),e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+2)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+2)+0.03465*pow((e_lvl_mob+2),2))*.2))
#	elif currentch>20:
#		var e_lvl_mob=((currentch-1)*3)+1 # ch1 moblvl 1,2,3 then ch2 lvl 4,5,6 ### base hp is what i need hp on gear and stuff !!! # fyi basehp forumla grow slower it will eventually get outnumbered!!! 
#		#### supose to have 1+ e_lvl... but didnt give so its easier!!
#		if chance==1: # lvl*4 *.25,.25 and .50 or 1,1,2
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob,e_lvl_mob*2,1,1,e_lvl_mob,e_lvl_mob*2,round(e_lvl_mob*2+e_lvl_mob*log(e_lvl_mob+1)*23),enemy1,"2hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.3))
#		elif chance==2:
#			e_name="rat"
#			createenemy((e_lvl_mob+1),(e_lvl_mob+1),(e_lvl_mob+1)*2,1,1,e_lvl_mob+1,e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+1)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+1)+0.03465*pow((e_lvl_mob+1),2))*.3))
#		elif chance==3:
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob*0.85,1,e_lvl_mob*2,1,e_lvl_mob*1.15,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob*2)*log(e_lvl_mob+1)*23),enemy1,"1hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.2))
#		elif chance==4 :
#			e_name="rat"
#			createenemy(e_lvl_mob,e_lvl_mob*1.5,e_lvl_mob*2.0,1,1,1+e_lvl_mob*0.5,e_lvl_mob*3,round(e_lvl_mob*2+(e_lvl_mob+1.5)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*e_lvl_mob+0.03465*pow(e_lvl_mob,2))*.3))
#		elif chance==5 :
#			e_name="rat"
#			createenemy((e_lvl_mob+2),(e_lvl_mob+2),(e_lvl_mob+2)*2,1,1,(e_lvl_mob+2),e_lvl_mob*2,round(e_lvl_mob*2+(e_lvl_mob+2)*log(e_lvl_mob+1)*23),enemy2,"2hsword",1,1,int(1+(-3.6+4.647*(e_lvl_mob+2)+0.03465*pow((e_lvl_mob+2),2))*.2))

###### type is just spawn chance 1= full str ( so good early game), 2= more str +crit,3=more crit then str, 4= ideal ish
func selectenemy(currentchapter,type): #type determine stat/ base name for enemy, level if it should give better loot or worse
	
	var enem=["rat",enemy1]
	if currentchapter==1  :
		enem=["rat1",enemy1]
	elif currentchapter<150:
		if type<3:
			enem=["rat1",enemy2]
	elif currentchapter<1000:
		if type<3:
			enem=["rat",enemy1]
		elif type>2:
			enem=["rat",enemy2]
	return enem
		#### maybe i should do stat based on enemy so select enemy first then 
#### fyi 2h=atk,str, 1h=agil,str, staff=wis,str
func createenemy(lvl,strength,atk,agi,wisdom,def,def_prot,e_hp,enemy,weapon,crit,luck,ebaseatk): # took out damage arguemnt as enemy already get from signal
		print("enemy lvl ",lvl)
		var Enemy= enemy.instance()
		if weapon=="2hsword":
			# statboast 
			pass
		elif weapon=="1hsword":
			pass
		elif weapon=="staff":
			pass
		Enemy.set_e_stats(lvl,strength,atk,agi,wisdom,def,def_prot,e_hp,enemy,weapon,crit,luck,ebaseatk)  #have to set player damage !!
		update_estat(lvl,def,def_prot) ### so we can easily send player info as soon as enemy is created
		#Enemy.set_e_damage_taken(damage)#get value from equipment and plug total atk# damage done by player # setting damage var
		Enemy.position=$Position2D.position
		add_child(Enemy)  
		get_node("enemy").connect("death",self,"_on_enemy_death") ### every instance of enemy hass its own signal
		get_node("enemy").connect("playerdied",self,"on_playerdied")
func _on_enemy_death(e_level):
	#remove_child(get_node("enemy"))
	$enemy.queue_free()
	$Timer.set_one_shot(true) #only send signal 1 instad of every 1 sec on timer start
	$Timer.start(1.1)
	emit_signal("expgain",e_level)
	emit_signal("dropitem",e_level,e_name)
func on_playerdied():
	$enemy.queue_free()
	$Timer.set_one_shot(true) #only send signal 1 instad of every 1 sec on timer start
	$Timer.start(1.1)

func _on_Timer_timeout():
	spawn() 
	#get_node("enemy").connect("death",self,"_on_enemy_death") # connect signal every spawn or just move to spawn function




	

## can send signal so player can go from def to idle
func _on_Map_maplevel(currentchapter): # can use same logic for next and prev button!!
	
	if get_child_count()>=3 and currentch!=currentchapter: # enemy still alive !! delete enemy and next map
		currentch=currentchapter
		$enemy.queue_free()
		$Timer.set_one_shot(true) #only send signal 1 instad of every 1 sec on timer start
		$Timer.start(4.0)
		
	elif currentch!=currentchapter:
		currentch=currentchapter
		yield(get_tree().create_timer(1.3),"timeout")
		if get_child_count()<=2:
			$Timer.set_one_shot(true) #only send signal 1 instad of every 1 sec on timer start
			$Timer.start(2.7)
	pass # Replace with function body.
