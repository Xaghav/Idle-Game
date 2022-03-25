extends Node2D
### when we add stat we have to add their label node her and also change their argument in signal form updown button!!!! lasty make sure they exis in stat and stattrack
var increment=1
var statpoints=4 ## total point ## used to keep track when we reset before confirming or levling up and stuff  
var statpointtrack=statpoints ### track totalpoint as we inc and dec !! 
var stat={"stre":1,"atk":1,"wis":1,"agil":1,"crit":1,"luck":1,"def":1} # actual stat once cofirm it will stay same
var stattrack={"stre":0,"atk":0,"wis":0,"agil":0,"crit":0,"luck":0,"def":0} # track of stat point as we inc/dec once confirm or reset this goes to 0 
var clickdmglvl=1
var clickmultilvl=1
var playerlevel=1
onready var save_load=load("res://resource/game/save.gd").new()
onready var player=get_tree().get_current_scene().get_node("player")
## stat point label
onready var stre=get_node("Panel/VBoxContainer/Panel1/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var atk=get_node("Panel/VBoxContainer/Panel2/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var wis=get_node("Panel/VBoxContainer/Panel3/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var agil=get_node("Panel/VBoxContainer/Panel4/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var crit=get_node("Panel/VBoxContainer/Panel7/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var luck=get_node("Panel/VBoxContainer/Panel6/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var def=get_node("Panel/VBoxContainer/Panel5/CenterContainer/HBoxContainer/Panel2/CenterContainer/Label2")
onready var statpointlabel=get_node("Panel9/CenterContainer/HBoxContainer/Panel3/CenterContainer/Label2")
onready var skillname=get_node("Panel2/HBoxContainer/Panel/CenterContainer/VBoxContainer/Panel3/CenterContainer/Label")
onready var skillstatname=get_node("Panel2/HBoxContainer/Panel/CenterContainer/VBoxContainer/Panel5/CenterContainer/HBoxContainer/Label")
onready var skillstat=get_node("Panel2/HBoxContainer/Panel/CenterContainer/VBoxContainer/Panel5/CenterContainer/HBoxContainer/Label2")
onready var skillcost=get_node("Panel2/HBoxContainer/Panel/CenterContainer/VBoxContainer/Panel6/CenterContainer/HBoxContainer/Label")
onready var clickdmg=get_node("Panel2/HBoxContainer/VBoxContainer/Panel9/CenterContainer/HBoxContainer/Panel")
onready var clickmulti=get_node("Panel2/HBoxContainer/VBoxContainer/Panel10/CenterContainer/HBoxContainer/Panel")
onready var gold=get_node("../../../../../Panel/Label") # this is on main lvl scene
onready var statinfo=get_node("VBoxContainer/statinfo")
onready var tutmessage=get_tree().get_root().get_child(0).get_node("AcceptDialog")
onready var arrow=load("res://resource/images/farm/arrow.png")
var acc=[1,1,1]
var currentskill=[]
var tut=0
signal stat_updated
signal tutdone
func _ready():
	loadstatinfo()
	statpointlabel.text=str(statpointtrack)
	if get_tree().get_current_scene().name=="level":
		player.connect("plvlup",self,"on_plvlup")
		self.connect("stat_updated",player,"on_plvl_stat_updated")
	updateskill("clickdmg")
	
	acc=[(round((float(atk.text)/((float(agil.text)/3)+(int(playerlevel)*1.5)))*100)),(round((float(agil.text)/((float(wis.text)/3)+(int(playerlevel)*2.7)))*100)),(round((float(wis.text)/((float(atk.text)/3)+(int(playerlevel)*2.2)))*100))]
	for i in range(acc.size()):
		if acc[i]>100:
			acc[i]=100
	statinfo.text=("Player Stats Vs Level "+str(playerlevel) +" monster"
	+"\nDamage:"+ "\n"+str(round(-3.6+4.647*(int(stre.text)+.65*int(luck.text)*1/((1250+playerlevel)*.0008)+.5*int(crit.text)*1/((1250+playerlevel)*.0008))+0.03465*pow((int(stre.text)+.65*int(luck.text)*1/((1250+playerlevel)*.0008)+.5*int(crit.text)*1/((1250+playerlevel)*.0008)),2) ))
	+"\n2H Accuracy: "+ "\n"+str(acc[0])+"%" 
	+"\nStaff Accuracy: "+"\n"+ str(acc[2])+"%"
	+"\n1H Accuracy: "+ "\n"+str(acc[1])+"%"
	+"\nHealth: "+"\n"+str(round(float((8*int(def.text)+0.035*pow(float(def.text),2.1))*4 )))
	+"\nCritical Hit Chance"+"\n"+str(stepify((((int(luck.text)-.5*playerlevel)/(int(luck.text)+2.5*playerlevel))+.2)*100,.01))+"%"
	+"\nCritical Damage")+"\n"+str(stepify((pow(int(crit.text)+600,.4)-12.92+.002*int(crit.text))*100,.01))+"%"
	### just have to emit signal with current stat when we press confirm!!!!
	#print("testing",Performance.get_monitor(Performance.TIME_FPS))
func on_plvlup():
	playerlevel+=1
	statpoints+=4
	statpointtrack+=4
	statpointlabel.text=str(statpointtrack)
	
func statinc(inc:int,incUpDown:String,statname):
	#### making sure increment is not bigger then avaliable point or if its bigger and we have point in stattrack then change inc point and take away point in that stattrack
	if incUpDown=="up": # stattrack inc
		if inc>statpointtrack:#inc is not bigger than current point avaliable
			inc=statpointtrack # if i am inc by 100 but only have 10 point then inc will be 10 for that instance !! if i have 0 point then inc will be 0 
		statpointtrack-=inc
		stattrack[statname]+=(inc)
		statpointlabel.text=str(statpointtrack)
		#print(stattrack,statpointtrack)
	elif incUpDown=="down": # stattrack dec
		if inc<stattrack[statname]:#current point in that stattrack is more then ince then i can dec that stattrack #if inc =10 but i have 5 point on that stattrack i shouldnt be able to dec that stattrack below 0 so inc has to be less then current statpoint
			statpointtrack+=inc
			stattrack[statname]-=(inc)
			statpointlabel.text=str(statpointtrack)
			#print(stattrack,statpointtrack,"aa")
		else: # if inc is greater then stattrack point ex inc=10 and stattrack =5 then i cant dec that stattrack more then 5 so we dec stattrack by 5 and add those 5 point to statpointtrack
			inc=stattrack[statname]
			statpointtrack+=inc
			stattrack[statname]-=inc
			statpointlabel.text=str(statpointtrack)
			#print(stattrack,statpointtrack)
	return inc

func _on_Button_button_down(incValue):
	increment=incValue


func _on_stat_button_down(statsname, UpDown):
	#print(statsname)
	var statchange=statinc(increment,UpDown,statsname)
	if UpDown=="up":
		get(statsname).text=str(int(get(statsname).text)+statchange)
		statinfo(statsname,statchange)
	elif UpDown=="down":
		get(statsname).text=str(int(get(statsname).text)-statchange)
		statinfo(statsname,statchange)
###### stat info update
func statinfo(statname,increments):
#	if statname=="stre":
#		statinfo.text="New Damage:"+ str(round(-3.6+4.647*(int(stre.text))+0.03465*pow((int(stre.text)),2))) +"\n atk \n wis \n def"
	acc=[(round((float(atk.text)/((float(agil.text)/3)+(int(playerlevel)*1.5)))*100)),(round((float(agil.text)/((float(wis.text)/3)+(int(playerlevel)*2.7)))*100)),(round((float(wis.text)/((float(atk.text)/3)+(int(playerlevel)*2.2)))*100))]
	for i in range(acc.size()):
		if acc[i]>100:
			acc[i]=100

	statinfo.text=("Player Stats Vs Level "+str(playerlevel) +" monster"
	+"\nDamage:"+"\n"+ str(round(-3.6+4.647*(int(stre.text)+.65*int(luck.text)*1/((1250+playerlevel)*.0008)+.5*int(crit.text)*1/((1250+playerlevel)*.0008))+0.03465*pow((int(stre.text)+.65*int(luck.text)*1/((1250+playerlevel)*.0008)+.5*int(crit.text)*1/((1250+playerlevel)*.0008)),2) ))
	#+"\n\nHit Chance Vs Level "+str(playerlevel) +" monster"
	+"\n2H Accuracy: "+"\n"+ str(acc[0])+"%" 
	+"\nStaff Accuracy: "+"\n"+ str(acc[2])+"%"
	+"\n1H Accuracy: "+"\n"+ str(acc[1])+"%"
	+"\nHealth: "+"\n"+str(round(float((8*int(def.text)+0.035*pow(float(def.text),2.1))*4 )))
	+"\nCritical Hit Chance"+"\n"+str(stepify((((int(luck.text)-.5*playerlevel)/(int(luck.text)+2.5*playerlevel))+.2)*100,.01))+"%"
	+"\nCritical Damage")+"\n"+str(stepify((pow(int(crit.text)+600,.4)-12.92+.002*int(crit.text))*100,.01))+"%"
func _on_statRedoConfirm_pressed(redoConfirm):
	if redoConfirm=="confirm":
		for i in (stat):
			stat[i]+=stattrack[i]
		statpoints=statpointtrack
		statpointlabel.text=str(statpointtrack) # dont really need here i guess
		emit_signal("stat_updated",stattrack,"stat")
		stattrack={"stre":0,"atk":0,"wis":0,"agil":0,"crit":0,"luck":0,"def":0}
	elif redoConfirm=="redo":# changed button name to undo but meh!
		stattrack={"stre":0,"atk":0,"wis":0,"agil":0,"crit":0,"luck":0,"def":0}
		statpointtrack=statpoints
		statpointlabel.text=str(statpointtrack)
		for i in stat:
			get(i).text=String(stat.get(i))
		#stre.text=String(stat.stre)
	if tut==7 and redoConfirm=="confirm" and stat["stre"]>1:
		tut=8
		tutmessage.visible=false
		update()
		print(self.connect("tutdone",get_parent().get_parent().get_child(0).get_child(0),"_on_tutdone",[],4))
		emit_signal("tutdone")
		
		
		##func display update on skill 
		### multiplyer going at linear rate of base dmg
func updateskill(skillnam):
	currentskill.append(get(skillnam))
	get(skillnam).icon=arrow
	if currentskill.size()>1:
		if currentskill[0]!=currentskill[1]:
			currentskill[0].icon=null
		currentskill.remove(0)
	if skillnam=="clickdmg":
		skillname.text="Click Damage"
		skillstatname.text="Damage:"
		skillstat.text=String(round((10+1.5*clickdmglvl+0.01465*pow(clickdmglvl,(1/3)))))
		skillcost.text=String(round(10*pow(1.015,clickdmglvl)+15*clickdmglvl))
		if clickdmglvl>785: # roughly lvl 785 the cost will skyrocket hence we gona lower it (gold drop/#of kill to lvl up/10)
			skillcost.text=String(round(((.0018*pow(clickdmglvl,2)+8.8*clickdmglvl+36)*(pow(clickdmglvl,3.2)+10))/(20*pow(clickdmglvl,2))))
	if skillnam=="clickmulti":
		skillname.text="Click Damage Multiplyer"
		skillstatname.text="Click Damage:"
		skillstat.text=String(clickmultilvl*3.5)+"%"
		skillcost.text=String(round((pow(1.16,clickmultilvl)+2000*clickmultilvl)-1000+clickmultilvl*5))
func _on_money_upgrade(skill):
		updateskill(skill)

#### buying skill and uses the display func we created earlier!!!
func _on_skillbuy():
	if skillname.text=="Click Damage" and int(gold.text)>=int(skillcost.text):
		gold.text=String(int(gold.text)-int(skillcost.text))
		emit_signal("stat_updated",int(skillstat.text),"skillclickdmg")
		clickdmglvl+=1
		updateskill("clickdmg") 
		if tut==2:
			tut=3
			update() 
	if skillname.text=="Click Damage Multiplyer" and int(gold.text)>=int(skillcost.text) :
		gold.text=String(int(gold.text)-int(skillcost.text))
		emit_signal("stat_updated",int(skillstat.text),"skillclickdmgmulti")
		clickmultilvl+=1
		updateskill("clickmulti") 
	if tut==2:
		tut=3
		update()
func _draw():
	if tut==1:#node get loaded when we click tab!! so this way it wont draw every time we switch node
		tutmessage.visible=true
		draw_rect(Rect2(20,-350,325,200),Color(1,.5,1,.5)) #all pannel canvasitem show behind parent==true so we can drop these on top of them
		draw_rect(Rect2(-5,-95,362,365),Color(.5,1,1,.5))
	elif tut==2: # buy skill tut
		draw_rect(Rect2(45,-343,120,30),Color(1,1,.5,.3))
		draw_rect(Rect2(167,-270,170,25),Color(.5,0,1,.5))
		draw_rect(Rect2(167,-242,170,60),Color(1,1,.5,.3))
		draw_rect(Rect2(80,-390,120,25),Color(.5,0,1,.5))
		tutmessage.rect_position=Vector2(60,250)
		tutmessage.get_ok().visible=false
		tutmessage.visible=true
		tutmessage.dialog_text="1.Select Click damage to upgrade it \n2.Make sure you have enough gold\n3.Click buy to Increase your\n click Damage by"+String(round((10+1.5*clickdmglvl+0.01465*pow(clickdmglvl,(1/3)))))+"\n4.Select buy to continue"
		tutmessage.rect_size=tutmessage.rect_min_size
#		yield(get_tree().create_timer(1),"timeout")
#		tutmessage.get_ok().visible=true
#		tutmessage.rect_size=tutmessage.rect_min_size
	elif tut==3:
		draw_rect(Rect2(160,-90,140,30),Color(.5,1,1,.5))
		tutmessage.dialog_text="1.Shows the Current skill Point \n2.Every level gives 4 point\n3.Press ok to continue"
		tutmessage.get_ok().visible=true
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(130,130)
		tutmessage.visible=true
		yield(tutmessage,"confirmed")
		tut=4
		update()
	elif tut==4:
		draw_rect(Rect2(2,32,223,236),Color(.5,.5,1,.5))
		draw_rect(Rect2(230,2,125,269),Color(.7,.7,1,.5))
		tutmessage.get_ok().visible=true
		tutmessage.dialog_text="           Upgrade stats \n1.Left side shows your current stat \n2.Right side shows stat info\n3.Stat info is based on stat point\n and enemy level\n4.Stat info shows stat based on \nfighting same level monster"  #\n5.ex 1 point in accuracy stat will give \n55% hit chance fighting against lvl 1 monster but \n30% hit chance fighting aginst lvl 2 monster "
		tutmessage.visible=true
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(50,60)
		yield(tutmessage,"confirmed")
		tut=5
		update()
	elif tut==5:
		draw_rect(Rect2(2,32,223,30),Color(.5,1,1,.5))
		draw_rect(Rect2(230,32,100,40),Color(.5,1,1,.5))
		draw_rect(Rect2(2,236,223,30),Color(.5,1,1,.5))
		draw_rect(Rect2(2,204,223,30),Color(.5,1,1,.5))
		tutmessage.get_ok().visible=true
		tutmessage.dialog_text="           Upgrade stats\n1.Strength,Luck,Crit increases damage"
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(50,145)
		tutmessage.visible=true
		yield(tutmessage,"confirmed")
		tut=6
		update()
	elif tut==6:
		draw_rect(Rect2(2,68,223,30),Color(.8,.8,1,.5))
		draw_rect(Rect2(230,68,100,35),Color(.8,.8,1,.5))
		
		draw_rect(Rect2(2,102,223,30),Color(.5,.7,1,.5))
		draw_rect(Rect2(230,105,100,33),Color(.5,.7,1,.5))
		
		draw_rect(Rect2(2,136,223,30),Color(.7,.4,1,.5))
		draw_rect(Rect2(230,140,100,33),Color(.7,.4,1,.5))
		
		draw_rect(Rect2(2,170,223,30),Color(.4,.4,1,.5))
		draw_rect(Rect2(230,175,100,33),Color(.4,.4,1,.5))
		
		draw_rect(Rect2(2,204,223,30),Color(.5,.1,1,.5)) ######fix
		draw_rect(Rect2(230,210,120,30),Color(.5,.1,1,.5))
		
		draw_rect(Rect2(2,236,223,30),Color(.5,1,1,.5))
		draw_rect(Rect2(230,242,100,30),Color(.5,1,1,.5))
		tutmessage.get_ok().visible=true
		tutmessage.visible=true
		tutmessage.dialog_text="           Upgrade stats\n1.Attack increases 2H weapon accuracy(axe)\n but decrease staff accuracy\n2.Wisdom increase staff accuracy \n but decreases 1H accuracy(sword)\n3.Agility increase 1h accuracy \n but decrease staff 2h accuracy\n4.Defense increases Hp and reduces \n% of incoming damage\n5.Luck increases Crit hit rate and damage\n6.Crit increases Crit Percent and damage"
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(50,30)
		yield(tutmessage,"confirmed")
		tut=7
		update()
	elif tut==7:
		draw_rect(Rect2(2,0,223,30),Color(.5,1,1,.5))
		draw_rect(Rect2(2,-87,77,23),Color(.5,.7,1,.5))
		draw_rect(Rect2(85,-87,73,23),Color(.2,.2,1,.5))
		draw_rect(Rect2(100,-60,100,23),Color(.5,.7,1,.5))
		draw_rect(Rect2(130,35,48,30),Color(.2,.2,1,.5))
		draw_rect(Rect2(180,35,45,30),Color(.5,.7,1,.5))
		tutmessage.get_ok().visible=false
		tutmessage.visible=true
		tutmessage.dialog_text="           Upgrade stats\n1.Multiply let you add multiple point at once\n2.Click on + to add stat and - to reduce\n3.Click undo to redistrube current point.\n4.Click Confirm to finalize the point \n5.Reset, will let you redistrube all your point\n6.Add 1 point to strength to continue\n7.Click on +1 by strength then Click confirm\n8.Stat will no be added unless you Click on confirm"
		tutmessage.rect_size=tutmessage.rect_min_size
		tutmessage.rect_position=Vector2(15,50)
		if stat["stre"]>1:
			tutmessage.get_ok().visible=true
			tutmessage.dialog_text="           Upgrade stats\n1.Multiply let you add multiple point at once\n2.Click on + to add stat and - to reduce\n3.Click undo to redistrube current point.\n4.Click Confirm to finalize the point \n5.Reset, will let you redistrube all your point\n6.Add 1 point to strength to continue\n7.Click on +1 by strength then Click confirm\n8.Stat will no be added unless you Click on confirm\n9.If strength point already added you can \npress ok to contine"
			yield(tutmessage,"confirmed")
			tut=8
			update()
			######problem maybe it willl connect multiple time if we keep switching the tab
			self.connect("tutdone",get_parent().get_parent().get_child(0).get_child(0),"_on_tutdone",[],4)
			emit_signal("tutdone")
		
func _on_tutcontinue():
	if tut==0:
		tutmessage.get_ok().visible=true
		tutmessage.visible=true
		tutmessage.dialog_text="1.Top Half shows the Player Skill \n2.Player skill cost gold to upgrade\n3.Player skill effect the damage that\n you could do via Attack button\n4.Bottom Half shows Player Stat\n5.Every level player gains 4 stat points"
		tut=1
		update()
		yield(tutmessage,"confirmed")
		tut=2
		update()
		
	
func savestatinfo():
	var statinfo=[[stat],[statpoints],[clickdmglvl,clickmultilvl,playerlevel],[tut]] # stat are current stat,statpoints are point avaliable!!
	save_load.save_game("updatestatinfo",statinfo)
	
	
func loadstatinfo():
	var statinform=save_load.load_game()
	if statinform.has("updatestatinfo"):
		stat=statinform.updatestatinfo[0][0]
		statpoints=statinform.updatestatinfo[1][0]
		statpointtrack=statpoints
		for i in stat:
			get(i).text=str(stat[i]) # using get cuz string type""
		clickdmglvl=statinform.updatestatinfo[2][0]
		clickmultilvl=statinform.updatestatinfo[2][1]
		playerlevel=statinform.updatestatinfo[2][2]
		tut=statinform.updatestatinfo[3][0]
		#print(player,clickdmglvl,clickmultilvl)
func _on_save_test_button_down():### save button but took it out so have to replace!
	savestatinfo()


func on_reset_button():
	emit_signal("stat_updated",stat,"resetstat")
	### reset statpoint and stat and labels
	statpoints=4*playerlevel
	statpointtrack=statpoints
	statpointlabel.text=str(statpointtrack)
	stat={"stre":1,"atk":1,"wis":1,"agil":1,"crit":1,"luck":1,"def":1}
	stattrack={"stre":0,"atk":0,"wis":0,"agil":0,"crit":0,"luck":0,"def":0}
	for i in stat:
		get(i).text=str(stat[i])
	statinfo("","")# no longer need it just does all at once
	
