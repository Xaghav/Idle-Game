extends Area2D
#### problem is if we click and kill enemy in the middle of the atk animation it will switch from walk state to def at end of atk animation hence walk animation wont play then!!! so need to figure if enemy is dead at end of atk animtion dont switch state to def

##### game break if i switch gear at end of atk animation!!! cuz that when postion changed and eqiupment become invis
### just control animation, exp and lvl(send signal to stat update everytime player lvl and  also get signal from that to get any stat change)!!!! and fight 
##things to save stats!!! so on ready give player full hp and enemy and player will start fresh with full hp
#### hp and label should be done in diff class!!! not in player as player should only have code of things player able to do!!!! like walk run, jump etc!!! hp , atk ,def  could all run own their own and call player to quee free or whatever is needed!
onready var enem=get_node("../spawn&death_track") ## to get enemy stats
onready var background=get_node("../ParallaxBackground/ParallaxLayer/background")
onready var inventory=get_node("../inventory/CenterContainer_inv/TabContainer/inventory/invetest")
onready var paraback=get_node("../ParallaxBackground")
onready var healthbar=get_node("TextureProgress")
onready var damagelabel=get_node("Label2")
onready var damageanimation=get_node("Label2/AnimationPlayer")
onready var attackbutton=get_node("attack") # no need took out disable from enemy enter and exit!!!
onready var eatbutton=get_node("heal")
onready var expbar=$TextureProgress2
onready var playerlvllabel=$TextureProgress2/Label2
var enemy= load("res://resource/game/enemy.tscn")
###var ga=combat.new() is same as preload("res://resource/game/combat.tres") then use .new()
var combat=preload("res://resource/game/combat.tres") ## make sure weapon name exist in combat file or it wont do right damage cuz i didnt specify on wrong name
###sword=str,agil counter int, 2h=str,atk, counter agil staff=int,str counter atk
### combat.damage("sword",10,1,30,1,1,1,1,1,10)) # weapontype,enemylvl,atk,stre,wisdom,agility,crit,luck,enemydef,enemydefprot
var combat_power=100
var offsetparaback=0
#####change these from boolean to state!!!!
onready var animationplayer=get_node("AnimationPlayer")
onready var animation=$AnimationTree.get("parameters/playback")
onready var save_load=load("res://resource/game/save.gd").new()
signal atking_done
signal plvlup
signal clickatk
var clickdmg=6
var clickdmgmulti=1
var player_stat={"atk":1,"stre":1,"agi":1,"wisdom":1,"crit":1,"luck":1,"def":1,"defprot":1,"hp":30,"plvl":1,"baseatk":0} #125 at start!!!
var pweapontype="2hsword"
var emptyhand="emptyhand"
var hp = phealth() setget set_hp
var damage:int=3
var pExpGain=0
var oldgear={"weapon":[],"helm":[],"armor":[],"accessory1":[],"weapon2h":[],"accessory2":[],"shield":[],"leg":[],"shoe":[]}
enum state{walk,attack,defense,dead,idle}#took out stun from state and now its in effect
var stunheal=false
var currentstate=state.walk
var def=true
var turn=0
var effect :Array=["none"] # store effect from enemy
var foodtimer:Array=[[],[]] # store time left till food ability expire
var foodbuff:Array # store 3 buff if player eat more then remove the first buff
onready var bufflabel=get_node("TextureProgress2/buff")
func _ready():
	
	
#########test
#	foodtimer[1].append(create_bufftimer(1,8))
#	foodtimer[1].append(create_bufftimer(2,8))
#	print(foodtimer[1][0].is_connected("timeout", self,"_on_timer_timeout"))
#	yield(get_tree().create_timer(4),"timeout")
#	foodtimer[1][0].queue_free()
#	print(foodtimer[1].remove(0),foodtimer)
	loadpinfo()
	
#	player_stat={"atk":1000,"stre":1000,"agi":1000,"wisdom":1000,"crit":1000,"luck":1000000,"def":10000,"defprot":10000,"hp":3000000000,"plvl":1000,"baseatk":100000}
#	clickdmg=60000
	
	
	expbar.set_as_toplevel(true)
	expbar.max_value=pow(player_stat.plvl,3.2)+10
	var victory=0
	var matches=30
	var a =1000 ### after 850, 300 def means less cuz 300 point gives 60% more atk vs 300def will only reduce 41(.59*dmg)
#	print((8*400+0.035*pow(400,2))*4)
#	for i in matches:
#		#if combat.testfight(420000,"2hsword",1000,1000,1250,2250,1,1,500,420000,"2hsword",1000,1000,1250,1050,700,500,500)=="playerwon":
#		#if combat.testfight(5500,"2hsword",1000,50,100,460,20,24,50,5500,"2hsword",1000,50,100,503,1,1,50)=="playerwon": 
#		#testfight(php,pweapon,pj,plvl,pstat1,pstat2,pstat3,pstat4,pstat5,ehp,eweapon,ej,elvl,estat1,estat2,estat3,estat4,estat5):
#		#3=crit,4=luck
#		##if combat.testfight(155000,"2hsword",1000,1000,1250,1500,1,1,1250,155000,"2hsword",1000,1000,1025,1980,180,315,500)=="playerwon": 
#		if combat.testfight(95500,"2hsword",1000,1000,1250,1500,1,1,1250,95500,"2hsword",1000,1020,1280,1540,1,1,1250)=="playerwon": 
#		#if combat.testfight(1000,"2hsword",13,1,21,33,1,1,1,1000,"2hsword",13,1,21,32,1,1,2)=="playerwon":
#			print("playerwon")
#			victory+=1
#		else:
#			print("playerlost")
#	yield(get_tree().create_timer(0.6),"timeout")
#	print("won:  ",victory," out of  ",matches, "  and lost ", matches-victory)
##
	
#		print(combat.testfight(5000*testlvl,"2hsword",1,10*testlvl,12*testlvl,19*testlvl,6*testlvl,3*testlvl,1,5000*testlvl,"2hsword",1,10*testlvl,16*testlvl,24*testlvl,1,1,1)) ##1h need like 21% def boost to win majority around 750 def, 600 won 4/6 with first hit
#	combat.testrun("2hsword",1000,1250,1400,2000,1000,600) #150k- 10% base-189k
#	combat.testrun("2hsword",1000,1250,1200,2700,700,400)   #206k- 10% base 228k -/100 instead of 200=244k
#	combat.testrun("2hsword",1000,1250,1200,2400,1000,400)  #238k
#	combat.testrun("2hsword",1000,1250,1400,3600,1,1)  #264k
#	print(combat.testrun("2hsword",1000,1000,923,2077,692,308,1))
#	print(combat.testrun("2hsword",1000,1000,923,2077,792,208,1)) 
#	print(combat.testrun("2hsword",1000,1000,1200,2800,1,1,1))

#	combat.testrun("2hsword",1000,10,16,24,1,1)
#	combat.testrun("2hsword",1000,10,12,19,6,3)
#	for i in 10:
##		get_damage("2hsword",8,6,18,1,1,6,5,1,1,5)
#		combat.testrun("1hsword",1,5,6,18,6,5)
#		combat.testrun("2hsword",1,5,6,27,1,1)
#		combat.testrun("2hsword",5,5,10,15,1,1) # 100hp avg per hit
#		combat.testrun("2hsword",5,5,6,10,6,4)
#		combat.testrun("2hsword",5,3,4,8,1,1) # 30-50hp
#	combat.testrun("2hsword",5,100,160,240,1,1) # rough 2k-2.5k hp for 5 round
#	combat.testrun("2hsword",5,100,120,190,60,30)
#	combat.testrun("1hsword",10000,100,160,240,1,1)
#	combat.testrun("1hsword",10000,100,120,190,60,30)
#	combat.testrun("staff",10000,100,160,240,1,1)
#	combat.testrun("staff",10000,100,120,190,60,30)
#	combat.testrun("2hsword",1000,10,11,20,1,9)
#	combat.testrun("2hsword",1000,4000,6400,9600,1,1)
#	combat.testrun("2hsword",1000,4000,4480,11520,1,1)
	###switch weapon
	#animationplayer.get_animation("swordattack").track_set_key_value(3,0,"staff") #track/key start at 0, 3=track,0 key aka(key at 0 sec cuz that where i added first key in that track!!!)
#	for i in range(7):
#		print(animationplayer.get_animation("swordattack").track_get_key_value(i,0))
	##### stat
	inventory.connect("stat_to_player",self,"on_update_stat_to_player")
	
	########damage
	healthbar.max_value=phealth()
	#hp=player_stat.hp
	healthbar.value=hp
	enem.connect("expgain",self,"on_expgain")
	print(player_stat,hp)
	pass
	# combat.testrun(weapon,itteration,lvl,atk/agi/intel,str)
#	combat.testrun("staff",100000,1200,100,3900)
#	combat.testrun("staff",100000,1200,700,3300)
#	combat.testrun("staff",100000,1200,800,3200)
#	combat.testrun("staff",100000,1200,900,3100)
#	combat.testrun("staff",100000,1200,1000,3000)
#	combat.testrun("staff",100000,1200,1100,2900)
#	combat.testrun("staff",100000,1200,1200,2800)
#	combat.testrun("staff",100000,1200,1300,2700)
#	combat.testrun("staff",100000,1200,1700,2300)
#	combat.testrun("staff",100000,1200,2000,2000)
#	combat.testrun("staff",100000,1200,3000,1000)
func phealth():
#	player_stat.def=1281
#	player_stat.plvl=4000
#	player_stat.hp=657355
#######player get hp boast!! from def vs enemy so they have some advantage 8(def*.5+....+pow(def.5)... prety much befre def*.5 now its 1 and .66
	var givehp=player_stat.hp +(round(float((8*int(player_stat.def*1+2*player_stat.plvl)+0.035*pow(float(player_stat.def*.6+2*player_stat.plvl),2.1))*2 )))# dont really need it here as this only need to update when we equip gear or inc stat but meh!
	return givehp
func get_damage(weapon,elvl,atkk,stre,wisdom,agi,crit,luck,edef,edefprot,plvl,batk):
	damage=combat.damage(weapon,elvl,atkk,stre,wisdom,agi,crit,luck,edef,edefprot,0,plvl,batk)
	return damage
func do_damage():
	# also have to add stun aswell
	## dont have to worry about stun cuz player wont do any damage!!!
	# if effect.has("effectname") ## then we will do half damage aka divde str/2 and base atk/2
	#	emit_signal("atking_done",get_damage(pweapontype,enem.estats.lvl,player_stat.atk,player_stat.stre/2,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot,player_stat.plvl,player_stat.baseatk/2),player_stat.def,player_stat.defprot,player_stat.plvl)
	#else:
	emit_signal("atking_done",get_damage(pweapontype,enem.estats.lvl,player_stat.atk,player_stat.stre,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot,player_stat.plvl,player_stat.baseatk),player_stat.def,player_stat.defprot,player_stat.plvl)
func set_hp(value): # value= damage he takes per hit
	hp=value
func set_p_damagetaken(edamage):
	hp-=edamage
	if hp<0:
		hp=0
	update_label_hp()
	
	
func stun(): # can make weakened stage where we do half the damage aka we half the stre value
#	if stunheal==true: ### just have to make sure potion make this true only if player is stun hence if they use other wize it just get wasted!!!! if currenstate=state.stun: stunheal=true:
#		currentstate=state.defense
#		stunheal=false
#		yield(get_tree().create_timer(0.6),"timeout")
	emit_signal("atking_done",0,player_stat.plvl,player_stat.def,player_stat.defprot) 
#	currentstate=2 # if i want to def.. if not enemy will just atk 2x faster cuz we skiping def


func update_label_hp():
	get_node("Label").set_text("HP:"+String(hp))
	healthbar.value=hp
	if hp>phealth():# lets say potion wear off and def goes from 100 to 0 so hp need to dec to normal
		hp=phealth()
		healthbar.value=hp
	healthbar.max_value=phealth()
#	print(phealth())
		
func defstate():
	if currentstate!=state.walk:
		currentstate=state.defense
### could just use false and true ato play animation with function but meh process is good too
func _process(delta)->void:# _delta if we not gona use it if we are going to use then we have to do delta
	bufflabel.text="" #to reset so it dont just keep appending the previous text aka same line
	if foodtimer!=null and foodtimer[1].size()>0:
		for i in range(foodtimer[1].size()):
			bufflabel.text=bufflabel.text+str(foodtimer[0][i*2])+": "+str(foodtimer[0][i*2+1])+"\n"+"Time left:"+str(round(foodtimer[1][i].time_left))+"sec\n"
			
	match currentstate:
		state.walk:
			if position.x<=189:
				position.x+=85*delta
			animation.travel("idle")
			if position.x>=189:
				offsetparaback-=60*delta #45 is good
				paraback.set_scroll_offset(Vector2(offsetparaback,0))
		state.attack:
			if hp==0:
				currentstate=state.dead
				return
			if effect.has("stun"):
				# check if we have potion to heal stun if not play stun animtion else continue
				#effect.remove(0) # heal/ remove stun
				#turn=0 # reset turn cuz after 3 turn/3 death auto remove stun
				animation.travel("stun")
				if turn>=3: # after 3rd death auto stun
					turn=0
					effect.remove(effect.find("stun"))
					# stop animation
			elif emptyhand=="emptyhand" :#and not effect.has("stun"):
				animation.travel("atk")
			elif emptyhand!="emptyhand" :#and not effect.has("stun"):
				animation.travel("swordattack")
			#print(get_damage("1hsword",enem.estats.lvl,player_stat.atk,player_stat.stre,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot))
			#emit_signal("atking_done",get_damage("1hsword",enem.estats.lvl,player_stat.atk,player_stat.stre,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot),player_stat.plvl,player_stat.def,player_stat.defprot)
			#### going to use animation to do damage and emit this signal via method property # func do_damage
			#print(animation.get_current_node()) 
			#currentstate=state.defense # stop atk animation some time...
		state.defense:
			if hp==0:
				currentstate=state.dead
				return
			animation.travel("defend")
			if def==false:# enemy die in middle of attak animation due to click atk then sate will go to def instead of walk( because walk state will be triggered in the middle of animation but at end of animation will change it to def so player will just def instead of walking and by keeping track with true and false we can rechange the state easily to walk when needed aka when enemy dead)!! 
				animation.travel("idle")
				currentstate=state.walk 
				def=true
#		state.stun:
#			animation.travel("stun")
		state.dead:
			animation.travel("dead")
			#print(hp," oo ",player_stat.hp)
			hp=phealth()#player_stat.hp  +(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 )))
			$CollisionShape2D.disabled=true
		#get_tree().reload_current_scene()
			if hp==phealth():#player_stat.hp +(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))):
				$CollisionShape2D.disabled=false
func ondeadturn():
	if effect.has("stun"):
		turn+=1
func _on_player_area_entered(_area)->void: # player atks then send signal
	def=true
	attackbutton.visible=true
	eatbutton.visible=true
	currentstate=state.attack
	#attackbutton.disabled=false  # dont matter enemy wont get signal anyway
#	atk=false # enemy atk first player def if we do atk false first and def true
#	def=true
	#offsetparaback=0 # so it dont grow infinintly large but it also reset the map which makes it weird
###########################took out recently dont need  not sure why i had it on
#	if effect.has("stun"):
#		animation.travel("stun")
#	elif emptyhand=="emptyhand":
#		animation.travel("atk")#"atk" ### we need to do inital atk animation here because the loop run but it wont play the animation for some reason
#	elif emptyhand!="emptyhand":
#		animation.travel("swordattack")
		
	if get_parent().get_node("spawn&death_track/enemy").is_connected("e_atking_done",self,"_on_enemy_e_atking_done")==false:
		get_parent().get_node("spawn&death_track/enemy").connect("e_atking_done",self,"_on_enemy_e_atking_done")
		


	
func _on_enemy_e_atking_done(e_damage,pickstate):
	set_p_damagetaken(e_damage) # enemy damage
	damagelabel.text=String(e_damage)
	damageanimation.play("showDamage")
	currentstate=state.attack
	
	if pickstate!="none": # make sure no did get any efect 
		if not effect.has(pickstate):
			effect.append(pickstate) # add the effect if we dont already have
#	if currentstate!=state.stun:
#		currentstate=pickstate

func _on_player_area_exited(_area)->void:
	attackbutton.visible=false
	eatbutton.visible=false
	#attackbutton.disabled=true # throug animatio no need
	if currentstate!=state.dead:
		animation.travel("idle")
		currentstate=state.walk  # add death and make it happen immediatly and it wont do the atk animation !! cant do immediate cuz it has to go to idle so it can send signal
		def=false
func on_expgain(elvl): ## we getting this signal from spawn and death
	#position.x=0 # enemy died player dead we change position form the animation
	pExpGain+=pow(elvl,2)
	expbar.value=pExpGain
	
	while pExpGain>=pow(player_stat.plvl,3.2)+10:#every lvlup= lvl^1.2 +10 #exp gain x^2 and lvlup= 5*x^3==>per lvl 5*x= every lvl has to kill +5 extra enemy with same lvl to level up
		player_stat.plvl+=1
		expbar.max_value=pow(player_stat.plvl,3.2)+10
		playerlvllabel.text="Level:"+String(player_stat.plvl)
		emit_signal("plvlup")

func _on_TabContainer_tab_changed(tab):
	if tab==0 or tab==1:
		visible=true
		enem.visible=true
		background.visible=true
		bufflabel.visible=true
		if tab==1:
			bufflabel.visible=false
			
	else:
		visible=false
		enem.visible=false
		background.visible=false
		bufflabel.visible=false
		##track current gear and its stat
func update_equipmentstats(stats):
	for i in range(stats.size()):
		if str (stats[i])=="Hp":
			#print(player_stat.hp," newhp ",stats[i+1])
			player_stat.hp=int(player_stat.hp)+int(stats[i+1])

		elif str (stats[i])=="atk":
			player_stat.atk=int(player_stat.atk)+int(stats[i+1])
		elif str (stats[i])=="str":
			player_stat.stre=int(player_stat.stre)+int(stats[i+1])
		elif str (stats[i])=="wisdom":
			player_stat.wisdom=int(player_stat.wisdom)+int(stats[i+1])
		elif str (stats[i])=="crit":
			player_stat.crit=int(player_stat.crit)+int(stats[i+1])
		elif str (stats[i])=="luck":
			player_stat.luck=int(player_stat.luck)+int(stats[i+1])
		elif str (stats[i])=="def":
			player_stat.def=int(player_stat.def)+int(stats[i+1])
		elif str(stats[i])=="defprot":
			player_stat.defprot=int(player_stat.defprot)+int(stats[i+1])
		elif str (stats[i])=="baseatk":
			player_stat.baseatk=int(player_stat.baseatk)+int(stats[i+1])
							
func update_equipmentoldstats(stats):
	for i in range(stats.size()):
		if str (stats[i])=="Hp":
			#print(player_stat.hp," oldhp  ",stats[i+1])
			player_stat.hp=int(player_stat.hp)-int(stats[i+1])
			#print(player_stat.hp," oldhp ",stats[i+1])
		elif str (stats[i])=="atk":
			player_stat.atk=int(player_stat.atk)-int(stats[i+1])
		elif str (stats[i])=="str":
			player_stat.stre=int(player_stat.stre)-int(stats[i+1])
		elif str (stats[i])=="wisdom":
			player_stat.wisdom=int(player_stat.wisdom)-int(stats[i+1])
		elif str (stats[i])=="crit":
			player_stat.crit=int(player_stat.crit)-int(stats[i+1])
		elif str (stats[i])=="luck":
			player_stat.luck=int(player_stat.luck)-int(stats[i+1])
		elif str (stats[i])=="def":
			player_stat.def=int(player_stat.def)-int(stats[i+1])
		elif str(stats[i])=="defprot":
			player_stat.defprot=int(player_stat.defprot)-int(stats[i+1])
		elif str(stats[i])=="baseatk":
			player_stat.baseatk=int(player_stat.baseatk)-int(stats[i+1])
#func store_oldstat_as_neg(equiped_gear): ###### for some reason its updating stat on other file aswell...
#	for i in range(oldgear[equiped_gear].size()):
#		if i%2==0: #remainder 0=even, remainder 1 = odd
#			oldgear[equiped_gear][i+1]=-1*(oldgear[equiped_gear][i+1])


######only sword updated axe didnt updated stat!!!!
func on_update_stat_to_player(equiped_stat,equiped_item): ## trigger when gear equiped!!! comes from signal
	# fyi unequip gear and if hp inc from equip then hp wont update until player die
	# other stat will updatefine!!!
	
	match equiped_item:
		"sword","axe","staff","weapon2h": ##### hp get updated at end of death so one can just equip high hp gear on last hit to get better hp then switch gear to better atk so now he will have high hp and higher stat for that round!! so what i could do is check oldgearhp>currentgearhp: this means current gear hp is worse so i have to update current hp (i dont even not to do that) just check if current hp is greater then the new maxhp if hp>playerstat.hp: then hp=playerstat.hp (this is after we update stat)
			emptyhand=equiped_item
			if equiped_item=="sword":
				pweapontype="1hsword"
			elif equiped_item=="staff":
				pweapontype="staff"
			elif equiped_item=="axe" or equiped_item=="weapon2h": # spec=weapon2h
				pweapontype="2hsword"
			if equiped_stat.size()==0:
				emptyhand="emptyhand"
				pweapontype="2hsword"
			animationplayer.get_animation("swordattack").track_set_key_value(3,0,equiped_item)
			update_equipmentoldstats(oldgear.weapon)## remove stat from previous gear!
			update_equipmentstats(equiped_stat) ## add stat of new gear
			oldgear.weapon=equiped_stat # store stat
			### lower hp if overall gear give less hp
			if hp>phealth():#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))): # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=phealth()#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))) ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp() ### in case gear give no def
			## just update min and max for stat bar but dont really need  to until player die but meh
			else:
				## hp+=int(stats[i+1]) # not good cuz player can just use to heal!!!
				update_label_hp()
			
			
			#oldgear.weapon[1]=int(oldgear.weapon[1])*-1 # yap if we do this += or *= then it update orignal
#			for i in range(oldgear.weapon.size()): ### somereason it changed the item stat vale on other file too
#				if i%2==0: #remainder 0=even, remainder 1 = odd
#					oldgear.weapon[i+1]=-1*(oldgear.weapon[i+1])
	# if shield equiped also remove 2h and animation will be atk unless have another weapon
	# if 2h equiped just remove shield # already done !! no need to do just have to switch animation to empty hand def!! when equiped_stat.size()==0
		"shoe":
			update_equipmentoldstats(oldgear.shoe)
			update_equipmentstats(equiped_stat)
			oldgear.shoe=equiped_stat
			if hp>phealth():#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))): # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=phealth()#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))) ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp() ### in case gear give no def
			else:
				## hp+=int(stats[i+1]) # not good cuz player can just use to heal!!!
				update_label_hp()
		"leg":
			update_equipmentoldstats(oldgear.leg)
			update_equipmentstats(equiped_stat)
			oldgear.leg=equiped_stat
			if hp>phealth():#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))): # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=phealth()#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))) ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp() ### in case gear give no def
			else:
				update_label_hp()
		"armor":
			update_equipmentoldstats(oldgear.armor)
			update_equipmentstats(equiped_stat)
			oldgear.armor=equiped_stat
			if hp>phealth():#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))): # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=phealth()#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))) ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp() ### in case gear give no def
			else:
				update_label_hp()
		"helm":
			update_equipmentoldstats(oldgear.helm)
			update_equipmentstats(equiped_stat)
			oldgear.helm=equiped_stat
			if hp>phealth():#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))): # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=phealth()#player_stat.hp+(round(float((8*int(player_stat.def)+0.035*pow(float(player_stat.def),2.1))*4 ))) ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp() ### in case gear give no def
			else:
				update_label_hp()
			
### stat we get from leveling up
func on_plvl_stat_updated(lvlup_stat,stype):
	if stype=="stat":
		player_stat.agi+=lvlup_stat.agil
		player_stat.atk+=lvlup_stat.atk
		player_stat.crit+=lvlup_stat.crit
		player_stat.def+=lvlup_stat.def
		player_stat.luck+=lvlup_stat.luck
		player_stat.stre+=lvlup_stat.stre
		player_stat.wisdom+=lvlup_stat.wis
		#print(lvlup_stat)
	elif stype=="skillclickdmg":
		clickdmg=lvlup_stat # since 6 is base
		#print(clickdmg)
	elif stype=="skillclickdmgmulti":
		#print(lvlup_stat)
		clickdmgmulti=1+float(lvlup_stat)/100
		#print(clickdmgmulti)
	elif stype=="resetstat":
		player_stat.agi-=lvlup_stat.agil-1
		player_stat.atk-=lvlup_stat.atk-1
		player_stat.crit-=lvlup_stat.crit-1
		player_stat.def-=lvlup_stat.def-1
		player_stat.luck-=lvlup_stat.luck-1
		player_stat.stre-=lvlup_stat.stre-1
		player_stat.wisdom-=lvlup_stat.wis-1
func _on_attack_pressed():
	attackbutton.disabled=true
	#if currentstate!=state.attack: # gona enable disable though animation so no need
	emit_signal("clickatk",round((clickdmg+player_stat.defprot)*clickdmgmulti))
	#print(clickdmg)
	yield(get_tree().create_timer(0.7),"timeout")
	attackbutton.disabled=false
func savepinfo():
	var playerinfo=[[player_stat],[hp,clickdmg,clickdmgmulti,emptyhand,pweapontype,turn,effect],[expbar.value,expbar.max_value],[oldgear]]
	save_load.save_game("playerinform",playerinfo)
func loadpinfo():
	var loadpinfo=save_load.load_game()
	if loadpinfo.has("playerinform"):
		player_stat=loadpinfo["playerinform"][0][0]
		hp=loadpinfo["playerinform"][1][0]
		clickdmg=loadpinfo["playerinform"][1][1]
		clickdmgmulti=loadpinfo["playerinform"][1][2]
		emptyhand=loadpinfo["playerinform"][1][3]
		pweapontype=loadpinfo["playerinform"][1][4]
		expbar.value=int(loadpinfo["playerinform"][2][0])
		pExpGain=expbar.value
		oldgear=loadpinfo["playerinform"][3][0]
		playerlvllabel.text="Level:"+str(player_stat.plvl)
		turn=loadpinfo["playerinform"][1][5]
		effect=loadpinfo["playerinform"][1][6]
		if emptyhand!="emptyhand":
			animationplayer.get_animation("swordattack").track_set_key_value(3,0,emptyhand)
			
func _on_savebutton_button_down(): # took out the button
	# testing save and load
	savepinfo()
	pass # Replace with function body.



func _on_heal_pressed():
	eatbutton.disabled=true
	var foodcure
	foodcure=inventory.foodslot(effect)
	print(foodcure)
	if foodcure[0]=="Hp heal":
		if hp<healthbar.max_value:
			hp+=foodcure[1]
			if hp>healthbar.max_value:
				hp=healthbar.max_value
			get_node("Label").set_text("HP:"+String(hp))
			healthbar.value=hp
	elif foodcure[0]=="buff":
		if foodtimer[0].has(foodcure[1]): # same buff already exit then just remove previous and add this instead
			var duplicatePosition=foodtimer[0].find(foodcure[1])
			foodtimer[1][duplicatePosition/2].queue_free()
			player_stat[foodtimer[0][0]]-=foodtimer[0][1]
			foodtimer[1].remove(duplicatePosition/2)
			foodtimer[0].remove(duplicatePosition)
			foodtimer[0].remove(duplicatePosition)
		foodtimer[0].append(foodcure[1])
		foodtimer[0].append(foodcure[2])
		player_stat[foodcure[1]]+=foodcure[2]
		if foodtimer[1].size()>=3:
			foodtimer[1][0].queue_free()
			player_stat[foodtimer[0][0]]-=foodtimer[0][1]
			foodtimer[1].remove(0)
			foodtimer[0].remove(0)
			foodtimer[0].remove(0)# dont need to do +1
			
		var bufftimer=create_bufftimer(foodcure[1],foodcure[3])
		foodtimer[1].append(bufftimer)
	elif effect.has(foodcure.back()):
		if foodcure[0]=="stun":
			#stop stun animation
			pass
		effect.remove(effect.find(foodcure[0]))
	print(foodtimer)
	yield(get_tree().create_timer(0.45),"timeout")
	eatbutton.disabled=false
func create_bufftimer(buff,bufftime):
	print(bufftime,"eeeee")
	var timer=Timer.new()
	add_child(timer)
	timer.set_wait_time (bufftime)
	timer.one_shot=true
	timer.connect("timeout", self,"_on_timer_timeout",[buff],4) 
	timer.start()
	return timer
func _on_timer_timeout(buff):# since cant have same buff so dont have to worry about identicalbuff
	print(buff,"ooooo")
	print(foodtimer)
	var buffposition=foodtimer[0].find(buff)
	player_stat[foodtimer[0][buffposition]]-=foodtimer[0][buffposition+1]
	foodtimer[0].remove(buffposition)
	foodtimer[0].remove(buffposition)#no need todo +1
	foodtimer[1][buffposition/2].queue_free()
	foodtimer[1].remove(buffposition/2)
	if foodtimer[1].size()==0:
		bufflabel.text=""
	print(foodtimer)
	pass
### to many bugs
#	if effect.has(foodcure.back()):
#
#		if foodcure[0]=="stun":
#			#stop stun animation
#			pass
#		effect.remove(effect.find(foodcure[0]))
#
#	elif foodcure!=null: # consume effect cure potion but effect array dont got it!!!
#		if foodcure[0]=="Hp heal":
#			if hp<healthbar.max_value:
#				hp+=foodcure[1]#foodcure.to_int()
#				if hp>healthbar.max_value:
#					hp=healthbar.max_value
#				get_node("Label").set_text("HP:"+String(hp))
#				healthbar.value=hp
#	yield(get_tree().create_timer(0.45),"timeout")
#	eatbutton.disabled=false
	pass # Replace with function body.
