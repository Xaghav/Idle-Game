extends Area2D
enum stats{e_attack,e_strength,e_defense,e_def_prot,e_wisdom,e_max_hp=10,e_crit,e_agi,e_luck,e_lvl,baseatk}
var e_weapon
onready var e_hp=stats.e_max_hp + (round(float((8*int(stats.e_defense*.5+2*stats.e_lvl)+0.035*pow(float(stats.e_defense*.5+2*stats.e_lvl),2.1))*2 ))) # current hp
onready var clickdmg=stats.e_max_hp
onready var label=get_node("Label")  #enemy&label child 
onready var enemy=get_parent().get_node("enemy") #enemy node if its isntace of child of INSTANCE in another scene (if its instance of child of that scene then .get_node("enemy")
var combat=preload("res://resource/game/combat.tres")
enum estate{ewalk,eattack,edefense,edead}
export var currentestate=estate.ewalk
export var eeffect:String
#onready var damage_taken # no need will get from player done atking signal

onready var e_damage:int=2
onready var e_movement =position
onready var e_animation=$AnimationTree.get("parameters/playback")
onready var damagelabel=get_node("Label2")
onready var damageanimation=get_node("Label2/AnimationPlayer")
var plvl=1
var pdef=1
var pdefprot=1
func _ready():
	#e_hp=stats.e_max_hp
	label.set_text(String(e_hp))
	print(stats,e_hp)
	#label= Label.new() # when enemy die it create new instance of label node with diff name so it could acces hp so gona make label node in level script
	#add_child(label)
	#label=get_node("enemy/@@2") #or could do label.name= ... and use that name instead of @@2
	pass 

func set_e_stats(lvl,strength,atk,agi,wisdom,def,def_prot,maxhp,enemy,weapon,crit,luck,ebaseatk):
	stats.e_attack=atk
	stats.e_strength=strength
	stats.e_defense=def
	stats.e_wisdom=wisdom
	stats.e_max_hp=maxhp
	e_weapon=weapon
	stats.e_agi=agi
	stats.e_crit=crit
	stats.e_luck=luck
	stats.e_lvl=lvl
	stats.e_def_prot=def_prot
	stats.baseatk=ebaseatk
func set_e_damage_taken(weapon,playerlvl,atk,stre,wis,agi,crit,luck,playerdef,playerdefprot,elvl,ebaseatk):
	e_damage=combat.damage(weapon,playerlvl,atk,stre,wis,agi,crit,luck,playerdef,playerdefprot,0,elvl,ebaseatk)
	return e_damage


func set_e_hp(value): ## used in class to take damage!!! not outside the class
	e_hp -=value
	if e_hp<=0:
		e_hp=0
	label.set_text("HP: "+String(e_hp)) # cant do label.set_text anymore becase in instance its no long just child of enemynode
	#label.set_position(position-Vector2(0,30))
	
func e_do_damage():
	var effect="none"
	randomize()
	if randi()%100<=10 and stats.e_lvl>50:
		effect=eeffect
	else:
		effect="none"
	emit_signal("e_atking_done",set_e_damage_taken(e_weapon,plvl,stats.e_attack,stats.e_strength,stats.e_defense,stats.e_agi,stats.e_crit,stats.e_luck,pdef,pdefprot,stats.e_lvl,stats.baseatk),effect)#null to send no effect# changed it to effect instead of state very last!! #1= atkstate for player 4=stun
	currentestate=estate.edefense
signal playerdied
signal e_atking_done
signal death
func _physics_process(delta):
	#label.set_position(position-Vector2(0,30))
	label.set_text("HP: "+String(e_hp))
	match currentestate:
		estate.ewalk:
			position.x -=100 *delta
			e_animation.travel("enemy_walk") 
		estate.eattack:  #have to make sure after run it dont go to idle if it does then if statement will happen before atk animtion
			if e_hp==0:
				currentestate=estate.edead
				return
			#print(e_animation.get_current_node())
			e_animation.travel("enemy_atk") # or i could just use yield(e_animation.travel("enemy_atk"),"completed")
#			if e_animation.get_current_node() =="enemy_idle": #again just have to make sure idle dont play before atk atnimation or it will go staright to this and no atk animation will happen!!!
#				#fyi again for this to work this need to auto go from atk to idle but have to make sure it dont auto go from walk and def to idle & both def and move need to go to atk    
#				emit_signal("e_atking_done",set_e_damage_taken(e_weapon,plvl,stats.e_attack,stats.e_strength,stats.e_defense,stats.e_agi,stats.e_crit,stats.e_luck,pdef,pdefprot))
		estate.edefense:
			if e_hp==0:
				currentestate=estate.edead
			e_animation.travel("enemy_def")
		#print(e_animation.get_current_node())
		#infinite spawn############################# just did to check how one enemy can keep sawning and stuff
		#if e_hp==0:
			######e_movement=Vector2(500,270) #dont need cuz its child of instace and position is diff now as intance
			#e_movement=Vector2(0,0) #spawn at(0,0) so it spawn at location of spawn&death node
			#e_hp=10
			#e_atk=false
			#e_def=false
			#e_move=true
			
			#get_tree().get_redload
		estate.edead:
			label.percent_visible=0
			emit_signal("death",stats.e_lvl)
			#queue_free()
	
func _on_enemy_area_entered(_area)->void: # _area means we dont need the area value but if we need we take out _ and do (area) instead of (_area)
	label.percent_visible=1
	currentestate=estate.edefense
#	e_atk=true # if i want enemy to atk first 
	if (get_parent().get_parent().get_node("player").is_connected("atking_done",self,"_on_player_atking_done"))==false:
		get_parent().get_parent().get_node("player").connect("atking_done",self,"_on_player_atking_done")
		get_parent().get_parent().get_node("player").connect("clickatk",self,"_on_player_clickatk_done")




func _on_player_atking_done(p_damage,pdefense,pdefprotection,plevel):
	#clickdmg=clickdmg-e_hp
	plvl=plevel
	pdef=pdefense
	pdefprot=pdefprotection
	#print(plvl,pdef,pdefprot)
	set_e_hp(p_damage)
	damagelabel.text=String(p_damage)#string(p_damage+clickdmg) #+" "+String(clickdmg)  # or i can emit that dmg button signal here and every time its click i can show its damage
	damageanimation.play("showDamage")
	currentestate=estate.eattack
	#clickdmg=e_hp
func _on_player_clickatk_done(p_clickdmg): ## signal not connected until player enter
	set_e_hp(p_clickdmg)
	damagelabel.text=String(p_clickdmg) 
	damageanimation.play("showClickDamage")



func _on_enemy_area_exited(_area)->void: #pretty much mean player not there aka dead!!! so start full hp and start again
	if e_hp!=0:
		emit_signal("playerdied")

#	label.percent_visible=0
#	e_hp=stats.e_max_hp
#	e_movement=Vector2(100,0)
#	e_move=true
#	e_def=false
#	e_atk=false
