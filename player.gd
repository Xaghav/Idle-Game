extends Area2D
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
var enemy= load("res://resource/game/enemy.tscn")
var combat=preload("res://resource/game/combat.tres") ## make sure weapon name exist in combat file or it wont do right damage cuz i didnt specify on wrong name
###sword=str,agil counter int, 2h=str,atk, counter agil staff=int,str counter atk
### combat.damage("sword",10,1,30,1,1,1,1,1,10)) # weapontype,enemylvl,atk,stre,wisdom,agility,crit,luck,enemydef,enemydefprot
var atk= false
var def=false
var idle=true
var combat_power=100
var pdead=false
var offsetparaback=0
var moveback=false
#####change these from boolean to state!!!!
onready var animationplayer=get_node("AnimationPlayer")
onready var animation=$AnimationTree.get("parameters/playback")
signal atking_done
signal plvlup
var player_stat={"atk":1,"stre":3,"agi":2,"wisdom":1,"crit":1,"luck":1,"def":2,"defprot":5,"hp":50,"plvl":1}
var hp = player_stat.hp  setget set_hp
var damage:int=3
var pExpGain=0
var oldgear={"weapon":[],"head":[],"armor":[],"accessory1":[],"weapon2h":[],"accessory2":[],"shield":[],"leg":[],"shoe":[]}
func _ready():
	
	###switch weapon
	#animationplayer.get_animation("swordattack").track_set_key_value(3,0,"staff") #track/key start at 0, 3=track,0 key aka(key at 0 sec cuz that where i added first key in that track!!!)
#	for i in range(7):
#		print(animationplayer.get_animation("swordattack").track_get_key_value(i,0))
	##### stat
	inventory.connect("stat_to_player",self,"on_update_stat_to_player")
	
	########damage
	healthbar.max_value=player_stat.hp
	hp=player_stat.hp
	healthbar.value=hp
	enem.connect("expgain",self,"on_expgain")
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
func get_damage(weapon,elvl,atkk,stre,wisdom,agi,crit,luck,edef,edefprot):
	damage=combat.damage(weapon,elvl,atkk,stre,wisdom,agi,crit,luck,edef,edefprot)
	return damage
func set_hp(value): # value= damage he takes per hit
	hp=value
func set_p_damagetaken(edamage):
	hp-=edamage
	if hp<0:
		hp=0
	update_label_hp()
	
	
func update_label_hp():
	get_node("Label").set_text("HP:"+String(hp))
	healthbar.value=hp
	healthbar.max_value=player_stat.hp# dont really need it here as this only need to update when we equip gear or inc stat but meh!
	
### could just use false and true ato play animation with function but meh process is good too
func _process(delta)->void:# _delta if we not gona use it if we are going to use then we have to do delta
	if idle== true and pdead==false and hp!=0 :
		if position.x<=189:
			position.x+=85*delta
		animation.travel("idle")
		if position.x>=189:
			idle=false
			moveback=true
	if moveback==true and hp!=0:
		offsetparaback-=60*delta #45 is good
		paraback.set_scroll_offset(Vector2(offsetparaback,0))
	if atk==true and hp!=0:
		animation.travel("swordattack")
		if animation.get_current_node() =="idle":
			atk=false
			def=true
			pdead=false## somethign is causing animtion to go weird where pdead dont become false so just gana try this
			#print(get_damage("1hsword",enem.estats.lvl,player_stat.atk,player_stat.stre,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot))
			emit_signal("atking_done",get_damage("1hsword",enem.estats.lvl,player_stat.atk,player_stat.stre,player_stat.wisdom,player_stat.agi,player_stat.crit,player_stat.luck,enem.estats.def,enem.estats.defprot),player_stat.plvl,player_stat.def,player_stat.defprot)
			#print(animation.get_current_node())
	if def==true and hp!=0:
		animation.travel("defend")
		
	if hp<=0:
		pdead=true
		animation.travel("dead")
		hp=player_stat.hp
		idle=true
		def=false # added now
		atk=false
		$CollisionShape2D.disabled=true
		#get_tree().reload_current_scene()
	if hp==player_stat.hp:
		$CollisionShape2D.disabled=false
		
	

func _on_player_area_entered(_area)->void: # player atks then send signal
#	atk=false # enemy atk first player def if we do atk false first and def true
#	def=true
	moveback=false
	#offsetparaback=0 # so it dont grow infinintly large but it also reset the map which makes it weird
	atk=true
	def=false
	idle=false
	animation.travel("atk")#"atk" ### we need to do inital atk animation here because the loop run but it wont play the animation for some reason
	if get_parent().get_node("spawn&death_track/enemy").is_connected("e_atking_done",self,"_on_enemy_e_atking_done")==false:
		get_parent().get_node("spawn&death_track/enemy").connect("e_atking_done",self,"_on_enemy_e_atking_done")
		


	
func _on_enemy_e_atking_done(e_damage):
	
	set_p_damagetaken(e_damage) # enemy damage
	damagelabel.text=String(e_damage)
	damageanimation.play("showDamage")
	def=false
	atk=true
	

func _on_player_area_exited(_area)->void:
	def=false
	atk=false
	idle=true  # add death and make it happen immediatly and it wont do the atk animation !! cant do immediate cuz it has to go to idle so it can send signal
func on_expgain(elvl):
	#position.x=0 # enemy died player dead we change position form the animation
	pExpGain+=pow(elvl,2)
	if pExpGain>=pow(player_stat.plvl,3)*5:#not much kill# every lvl has to kill +5 extra enemy with same lvl to level up
		player_stat.plvl+=1
		emit_signal("plvlup")

func _on_TabContainer_tab_changed(tab):
	if tab==0 or tab==1:
		visible=true
		enem.visible=true
		background.visible=true
	else:
		visible=false
		enem.visible=false
		background.visible=false
		##track current gear and its stat
func update_equipmentstats(stats):
	for i in range(stats.size()):
		if str (stats[i])=="hp":
			player_stat.hp=int(player_stat.hp)+int(stats[i+1])
			if hp>player_stat.hp: # just making sure if new gear stat would lower hp if so and current hp higher then new max hp then we update current hp to new max
				hp=player_stat.hp ## we dont need to update right now if its lower cuz that would heal the player and at end of round it will auto update anyway
				update_label_hp()
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
			
func update_equipmentoldstats(stats):
	for i in range(stats.size()):
		if str (stats[i])=="hp":
			player_stat.hp=int(player_stat.hp)-int(stats[i+1])
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
#func store_oldstat_as_neg(equiped_gear): ###### for some reason its updating stat on other file aswell...
#	for i in range(oldgear[equiped_gear].size()):
#		if i%2==0: #remainder 0=even, remainder 1 = odd
#			oldgear[equiped_gear][i+1]=-1*(oldgear[equiped_gear][i+1])


######only sword updated axe didnt updated stat!!!!
func on_update_stat_to_player(equiped_stat,equiped_item): ## trigger when gear equiped!!! comes from signal
	match equiped_item:
		"sword","axe","staff": ##### hp get updated at end of death so one can just equip high hp gear on last hit to get better hp then switch gear to better atk so now he will have high hp and higher stat for that round!! so what i could do is check oldgearhp>currentgearhp: this means current gear hp is worse so i have to update current hp (i dont even not to do that) just check if current hp is greater then the new maxhp if hp>playerstat.hp: then hp=playerstat.hp (this is after we update stat)
			animationplayer.get_animation("swordattack").track_set_key_value(3,0,equiped_item)
			update_equipmentoldstats(oldgear.weapon)## remove stat from previous gear!
			update_equipmentstats(equiped_stat) ## add stat of new gear
			oldgear.weapon=equiped_stat # store stat
			#oldgear.weapon[1]=int(oldgear.weapon[1])*-1 # yap if we do this += or *= then it update orignal
#			for i in range(oldgear.weapon.size()): ### somereason it changed the item stat vale on other file too
#				if i%2==0: #remainder 0=even, remainder 1 = odd
#					oldgear.weapon[i+1]=-1*(oldgear.weapon[i+1])
	# if shield equiped also remove 2h and animation will be atk unless have another weapon
	# if 2h equiped just remove shield
### stat we get from leveling up
func on_plvl_stat_updated(lvlup_stat):
	player_stat.agi+=lvlup_stat.agil
	player_stat.atk+=lvlup_stat.atk
	player_stat.crit+=lvlup_stat.crit
	player_stat.def+=lvlup_stat.def
	player_stat.luck+=lvlup_stat.luck
	player_stat.stre+=lvlup_stat.stre
	player_stat.wisdom+=lvlup_stat.wis
	print(lvlup_stat)
