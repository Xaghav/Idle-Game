extends Resource
class_name combat
### this will save as gd but after that we can create new resouce and resouce will have this file and we can then just save that resouce as tres!!! to use further
var test1=0
var test=1000
var l=0
var k=0
func _ready():
	
#	for i in 10:
#			test1+=damage("2sword",4000,8000,8000,1,1,1,1,1,1)
#	print(test1/10,"test   ")
#			#pass # Replace with function body.
	pass
func testfight(php,pweapon,pj,plvl,pstat1,pstat2,pstat3,pstat4,pstat5,pstat6,baseatk,ehp,eweapon,ej,elvl,estat1,estat2,estat3,estat4,estat5,estat6,ebaseatk):
	### player hp updated on normal play by ...pstat5*1+..pow(pstat5*.6
	var playerhp=php+(8*(pstat5*.5+plvl*2)+0.035*pow((pstat5*.5+plvl*2),2.1))*2 #.2 might be op might change to just 2.0
	var enemyhp=ehp+(8*(estat5*.5+elvl*2)+0.035*pow(estat5*.5+elvl*2,2.1))*2
	var pavgdmg=0
	var eavgdmg=0
	var turn=0
	
	print("pavg dmg ",pavgdmg," php ",playerhp, " eavg dmg ", eavgdmg," ehp ",enemyhp)
	while playerhp>0 and enemyhp>0:
		turn+=1
		var edmg=testrun(eweapon,ej,plvl,estat1,estat2,estat3,estat4,pstat5,pstat6,elvl,ebaseatk)
		var pdmg=testrun(pweapon,pj,elvl,pstat1,pstat2,pstat3,pstat4,estat5,estat6,plvl,baseatk)
		enemyhp-=pdmg
		playerhp-=edmg
		pavgdmg+=pdmg
		eavgdmg+=edmg
		print("ehp: ",enemyhp,"   pdmg  :  ",pdmg,"  php : ",playerhp," edmg: ",edmg)
	#print("ehp: ",enemyhp,"  php : ",playerhp)
	pavgdmg=pavgdmg/turn
	eavgdmg=eavgdmg/turn
	print(k," ",l," pavg dmg ",pavgdmg," php ",playerhp, " eavg dmg ", eavgdmg," ehp ",enemyhp)
	if enemyhp<=0:
		return "playerwon"
	else:
		return "playerlost"
func testrun(weapon,j,elvl,stat1,stat2,stat3,stat4,stat5,stat6,plvl,baseatk): # 1=acc,2=str,3=crit,4=luck/critchance
	
	var test2=0
	if weapon=="2hsword":
		test2=damage(weapon,elvl,stat1,stat2,1,1,stat3,stat4,stat5,stat6,0,plvl,baseatk)
	if weapon=="1hsword":
		test2=damage(weapon,elvl,1,stat2,1,stat1,stat3,stat4,stat5,1,0,plvl,baseatk)
	if weapon=="staff":
		test2=damage(weapon,elvl,1,stat2,stat1,1,stat3,stat4,stat5,1,0,plvl,baseatk)#0.5*(-3.6+4.647*plvl+0.03465*pow(plvl,2)
	return test2
#	for i in j:
#		if weapon=="2hsword":
#			test2+=damage(weapon,lvl,stat1,stat2,1,1,stat3,stat4,1,1,0,lvl)
#		if weapon=="1hsword":
#			test2+=damage(weapon,lvl,1,stat2,1,stat1,stat3,stat4,1,1,0,lvl)
#		if weapon=="staff":
#			test2+=damage(weapon,lvl,1,stat2,stat1,1,stat3,stat4,1,1,0,lvl)
#	print(test2/j)

func damage(weaponequip:String,enemylvl:float,atk:float=1,stre:float=1,wis:float=1,agil:float=1,crit:float=1,luck:float=1,enemydef:float=1,enemydefprot:=1,critbasechance:float=0,lvl:float=1,baseatk:=0): # default value but has to call the value before ex to change str since its 2nd value we haveto also write atk value ex damage(1,100)
	## with current stat end game just need 2 crit in 7 hit to kill at same rate with normal stat so odd are 2/7=28% probability of it happening on first hit is (2/7)/(5/2) roughly 21% with 1 full point in luck we have 34% chance of crit and chances of that happening/ prob is 22% which is perfect!!! 
	
	### only need to run and change value when we equip something new with stre or stat change 
	#print(atk," ",stre," ",crit," ",luck," ",enemydef," ",enemydefprot," ",enemylvl,lvl," ",baseatk)
	stre=(stre+.65*luck*1/((1250+enemylvl)*.0008)+.5*crit*1/((1250+enemylvl)*.0008))#stre+.65*luck*1/((625+enemylvl)*.0016)+.5*crit*1/((625+enemylvl)*.0016)#fine takes 9-3
	var dmg=-3.6+4.647*stre+0.03465*pow(stre,2)+baseatk 
	var dmgchance=1 # 1 max=100% hit 
	randomize()
	var chance=randi()%100+1
	chance*=.01
	if weaponequip=="2hsword":
		dmgchance=atk/((agil/3)+(enemylvl*1.5))
		if dmgchance>=chance:#only trigger when chance is less then dmgchnace aka acc between 0 and dmgchance # chance of doing bonus % of random%*missing dmg+base accuracy aka will not hit 100% unless 100% acc!! so 60% acc means missing 40% so if random number is less then .6 then that randomnumber aka number between 0 and .6 *.4+.6 max= .84
##		#ex dmgchance=75% that means 75% dmg confirm and rest 25% will be random(1-75=25) so number between 0-75*.25+.75!!!so 18% dmg bonus amx so max hit is 93%
		## ex lets say your acc is 5% then only 5% random chance of triggering the if dmgchance>=chance even then you will do #between 0 and .05*.95+.05 so max hit will be .0975% aka 9.75%
			dmgchance=chance*(1-dmgchance)+dmgchance
		###if not then we just do what ever our accurcy/dmgchance percent that you currently have
	elif weaponequip=="staff": # agil dem dmg
		dmgchance=wis/((atk/3)+(enemylvl*2.2))
		if dmgchance>=chance:
			dmgchance=chance*(1-dmgchance)+dmgchance
	elif weaponequip=="1hsword": # atk dec dmg
		dmgchance=agil/((wis/3)+(enemylvl*2.7))
		if dmgchance>=chance:
			dmgchance=chance*(1-dmgchance)+dmgchance
	if dmgchance>1:
		dmgchance=1
	dmg=dmg*dmgchance
	
#######################old redo ^
	### run everytimebefore attacking but meh
# every lvl must do min 2.5point in atk and 0 in wis for 100% or u have random chance of doing 100% hit even at lower lvl# we need ratio between atk and enemy lvl point !! atk-(wis/3)-(enemylvl*2.5) # so every lvl u need have 2.5 acc or 5point every 2 lvl to do 100% hit chance (leaving u with only 1 extra point so chance of this happening low whihc is perfect!!!)
#1/4 stat in acc gives pretty nice damage
# 2.5* enemy lvl < current atk= 100% if not  then we take ratio of current atk and enemy lvl*2.5 then random number between 0and 1 so u have random chance of hitting!!! higher ur atk value more chance of hitting 
# if u still get miss on 100% u do what ever percent of ur ratio then with min of 10% damage
##### 2h atk but agil lower, 1h agil but int lower, staff int inc atk lower
#	if weaponequip=="2hsword":
#		dmgchance=atk/((agil/3)+(enemylvl*2.5))
#		#randomize()
##		if dmgchance>=chance:# chance of doing 100% dmg, dmgchance % dmg is confirmed rest is luck
##			#ex dmgchance=75% that means 75% dmg confirm and rest 25% will be random(1-75=25) so randf().25+.75!!!
##			#dmgchance=1
##			#dmgchance=randf()*dmgchance
##			dmgchance=randf()*(1-dmgchance)+dmgchance
##		else: # damagechance value is lower then random so instead of no hit!!!! it will do the dmgchance% aka accuracy and lowest we can do is 10%
##			#dmgchance=0
##			if dmgchance<.1: # so always able to do 0-10% damage even at 0% accuracy
##				dmgchance=0.1
##			dmgchance=randf()*dmgchance # this is where extra bit of damge come aside from given % # so player can still hit % of hit depending on their hit chance
#
#	if weaponequip=="staff": # agil dem dmg
#		dmgchance=wis/((atk/3)+(enemylvl*3.3))
#		if dmgchance>=chance:
##			dmgchance=1
#			dmgchance=randf()*(1-dmgchance)+dmgchance
#		else:
#			if dmgchance<.1:
#				dmgchance=0.1
#	if weaponequip=="1hsword": # atk dec dmg
#		dmgchance=agil/((wis/3)+(enemylvl*3.6))
#		if dmgchance>=chance:
##			dmgchance=1
#			dmgchance=randf()*(1-dmgchance)+dmgchance
#		else:
#			if dmgchance<.1:
#				dmgchance=0.1
#	print(dmgchance)
#	dmg=dmg*dmgchance ###### now random atk depend on atk stat
#######################
	##### luck and crit!!
	 #### /150 and base 1.7587 makes crit worth!! with stat lvl-1250,atk-1200+,str-2700,crit-900,luck-400)  
	### had (crit/200)+1 but /100 seems way balanced
	#var critdmg=(crit/35) ## every 100crit point gives 10% crit damage if critchance is 10%
#	var critdmg=pow(crit,0.1)*log(crit)
#	#var critchance=log(log(1.9*luck+650))*1.04-1.8587+critbasechance # this inc base so i took out1.04 and inc 1.9 to 7 so we jsut gain % faster!!! it gets better after 125point!!!
#	var critchance=(log(log((4.5)*luck+650))-1.8587+critbasechance)#4*#critbasechance goes by decimal .01=1% inc ##1=1%chance,100=4.8%,1000=20% # lower 1.8587 will inc base % ex 1.6587 will give 21% at lvl 1
	#print(critchance) # have to fix !!!!

	##########
	## bigger then sum of the atk percent rise the nrest 
	var critdmg=pow(crit+600,.4)-12.92+.002*crit#pow(crit+100,.4)-6.31# barly make diff+log(crit*.001+1)#just need to slow down more early on#log(crit*.001+1)+pow(crit+100,.3)-3.981#better but notquiet yet #log(crit*.1+1)#pow(crit,.84)-.09*crit#(crit*log(crit))/800#works just too fast#(3.55*log(crit+.12)/2.303+(crit+24015)*.0000122-log(pow(crit,log(.003*crit)/2.303))/2.303)
#	luck=luck+16
	var critchance= (((luck-.5*enemylvl)/(luck+2.5*enemylvl))+.2)#every lvl:1pt34%,2pt53,3pt65,4#74#(((crit-enemylvl)/(crit+enemylvl))+1)*.625#too op maybe#add all point we get from lvl then 100% if we do 1 point every lvl then 62.5,2pt83,3pt93,4pt1#((1-(1/(8*log(luck-14)/2.303+25+luck/800))*10)-.64)
#	#########
#	k+=1
	if critchance>=chance:
		#print("crit")
		dmg=dmg*(critdmg+1) #+1 cuz we adding dmg+crt% * dmg
#		print([critdmg,critchance,chance])
		l+=1
	#####maybe take out defprot from here     ### (dmg-enemydefprot)*(1/(pow(enemydef,.233)))
	
#		print([critdmg,critchance,chance])
#		l=0
	#var dmgAfterdef=(dmg-enemydefprot)*(1/(pow(enemydef+.2,.09))) #+1,.078 before# has to do it in the end before 1/(.0003x+1.001) this is linear  so evenually this grows faster then current one!! current one start faster then get slower which is perfect for early lvl and it grow super slow after 1.9k which is perfect!! cuz max lvl 1k even if it was 2-3k it be fine ish probably cuz that when dmg growth slow down aswell
	var dmgAfterdef=(dmg-enemydefprot)*((.32/(.88*pow(enemydef,.05)))+(1/pow(28*enemydef+22.2,.09))-(1/(7.55*enemydef+22)))
	#print([dmg,enemydefprot,((.32/(.88*pow(enemydef,.05)))+(1/pow(28*enemydef+22.2,.09))-(1/(7.55*enemydef+22))),dmgAfterdef])
	#print(dmgAfterdef," ",dmg,"  ",enemydefprot," ",enemydef," ",(1/(pow(enemydef+.2,.09))))
#	if lvl-enemylvl>10: # after 10 lvl for every level the unit is higher then enemy lvl they will do 1%per lvl until it cancels all the def!!! aka 100% dmg
#		dmgAfterdef=dmgAfterdef*(1+(lvl-enemylvl)*.01)
		#print("aaaa",dmgAfterdef," ",(1+(lvl-enemylvl)*.01))
	#print(dmgAfterdef,"hmm ",(1/(pow(enemydef+.2,.09))) )
	if dmgAfterdef<dmg*.1: ## so no matter what the min damage player can get is 10% in case they able to get 91-100% protection
		dmg=dmg*.1
	else:
		#print(dmgAfterdef," ",dmg, dmgAfterdef<dmg)
		if dmgAfterdef<dmg:
			dmg=dmgAfterdef
	if dmg<2:
		dmg=2
	return dmg
###combat.testrun("2hsword",10000,1250,1400,2000,1000,600) ## if we inc base crit chance by 40% then this will be worth !!! more to do right now its not so i will have gear that inc base by 10-20% crit chance but have to have min 400-600 crit or something!!!log(log(1.9*luck+650))-1.6587
####combat.testrun("2hsword",10000,1250,2060,2940,1,1)
###combat.testrun("2hsword",10000,1250,1200,2700,900,400) made mistake combat.testrun("2hsword",10000,1250,1200,2700,700,400)# diff numb!!-> better #206k- 10% base 275k -/100 instead of 200 then damge 284k
#####combat.testrun("2hsword",10000,1250,1400,3600,1,1)  #264k
### sword then staff then 2h!!! 2h do the most damage
