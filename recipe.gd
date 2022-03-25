extends Resource
class_name recipess
# easier to add newer item ( have to add here +price+ add how to get it part(drop,shop,farm)and recipes(easier just have to add the item name ingrident and what it does here)
### fyi shop item also need to add (recipe stuff )in both item and invenitem dictionary because when we load we load by type and if its not seed then itlooks in invenitem but while game running it looks in item to find price for shop
var item={"WaterCan":[300,(Rect2(4,4,35,35)),"recipe"],
			"plant1":[70,(Rect2(39,4,35,35)),"seed"],
			"plant2":[150,(Rect2(74,4,35,35)),"seed"],
			"plant3":[500,(Rect2(109,4,35,35)),"seed"],
			"plant4":[1300,(Rect2(4,39,35,35)),"seed"],
			"plant5":[1400,(Rect2(39,39,35,35)),"seed"],
			"plant6":[1500,(Rect2(74,39,35,35)),"seed"],
			"plant7":[1500,(Rect2(109,39,35,35)),"seed"],# lower the amount of mushroom per farm so when u cook it gets more expense for later lvl!!!
			"milk":[1500,(Rect2(109,109,35,35)),"recipe"],
			} 
			#### we send region to text rect aka slot script!! these are drop images!!
var invenitem={"WaterCan":[(Rect2(4,4,35,35)),"recipe"],
			"milk":[(Rect2(109,109,35,35)),"recipe"],
			"carrot":[(Rect2(4,74,35,35)),"recipe"], #carrot !! since i know which is what i only wrote name on the shop tab
			"herb":[(Rect2(39,74,35,35)),"recipe"], #herb( organo?
			"corn":[(Rect2(74,74,35,35)),"recipe"],   #corn
			"radish":[(Rect2(109,74,35,35)),"recipe"], #radish
			"sugarcane":[(Rect2(4,109,35,35)),"recipe"], #sugarcane
			"mushroom":[(Rect2(39,109,35,35)),"recipe"], #mushroom
			"wheat":[(Rect2(74,109,35,35)),"recipe"],
			"dough":[(Rect2(152,4,70,70)),"recipe"],
			"oil":[(Rect2(152,80,70,70)),"recipe"],
			"sugar":[(Rect2(4,152,70,70)),"recipe"],
			"butter":[(Rect2(80,156,70,70)),"recipe"],
			"cheese":[(Rect2(156,156,70,70)),"recipe"],
			"sand":[(Rect2(80,232,70,70)),"recipe"],
			"flask":[(Rect2(4,228,70,70)),"recipe"]
			}
			###fyi can only get 1 type of buff stat ex only can get 1 def buff if we eat 2 diff food that give def buff then it will override first food def buff that u got with food 2
			## need to add food with buff for each stat and buff for higher lvl and high lvl heal
var recipes={0:{"corn":[]},
			1:{"sugarcane":[]},
			2:{"mushroom":[],"WaterCan":[],"carrot":[]},
			3:{"dough":[],"sugar":[],"butter":[],"carrot":[]},
			4:{"milk":[]},
			5:{"carrot":[],"WaterCan":[]},
			6:{"wheat":[],"WaterCan":[]},
			7:{"flask":[],"WaterCan":[],"herb":[]},
			8:{"dough":[],"cheese":[],"mushroom":[],"oil":[]},
			9:{"herb":[],"WaterCan":[],"milk":[]}, # tech herb(nestle leaf)+water= rennet and then rennet +milk + salt= cheese
			10:{"milk":[],"sugar":[],"butter":[]},
			11:{"carrot":[]},
			12:{"sand":[]},
			13:{"carrot":[],"WaterCan":[],"herb":[]}
			}# need to add ice cream and pizza
var recipesname=[["oil","recipe"],#0----------
				["sugar","recipe"],#1-----------
				["mushroom soup","food",["Value",1100,"Cure ","Hp heal","Hp",1200]],#before 640#2#min_cost=1500/4+300+70/2=710,ing- 734 # profit`266ish or -105, which is around same amount profit if we did cheese
				["cake","food",["Value",10000,"Cure ","Hp heal","Hp",8000]],#3 #before 8100#cost ratio means 8k heal but enemy lvl suggest 50kish#ing sell cost 1650+1620+6020+21=9311 so hpheal= 9311/734*640(less then this number) # lvl 900ish drop 9K per kill but they have 700k hp so this heal aint enough
				["butter","recipe"],#4----------
				["carrot soup","food",["Value",380,"Cure ","stun"]],#5
				["dough","recipe"],#6---------
				["health potion","food",["Value",460,"Cure ","revive","Hp",100]],#7
				["pizza","food",["Value",100,"Cure ","buff","def",25,"time",100]],#time in sec#8 ing sell cost=1650+2250+
				["cheese","recipe"],#9-----------
				["ice cream","food",["Value",100,"Cure ","buff","stre",20,"time",100]],#10 #costish-365*2+1500+6020
				["Carrot","food",["Value",90,"Cure ","Hp heal","Hp",100]],#11 #before 65 min ing sale cost-84, ing cost70~lvl 1-15 drop45-168gold and hp around 100-1k
				["flask","recipe"],#12-------------
				["Savory Carrot","food",["Value",500,"Cure ","Hp heal","Hp",640]]#before 340#lvl 289++#min ingredient sale cost-389,ing cost372~lvl15-60ish +drop400ish and hp around 1-10k (372/70~5.3 so heal should be 5*carrot hp heal
				] ## need more buff food and enemy to drop ingrident at x lvl to make heal potion for higher lvl
var sellprice={"WaterCan":item.WaterCan[0]*.9,
			"plant1":round(item.plant1[0]*.9),
			"plant2":round(item.plant2[0]*.9),
			"plant3":round(item.plant3[0]*.9),
			"plant4":round(item.plant4[0]*.9),
			"plant5":round(item.plant5[0]*.9),
			"plant6":round(item.plant6[0]*.9),
			"plant7":round(item.plant7[0]*.9),#### profit are calculated based on time it took to grow
			"milk":round(item.milk[0]*.9), ### if we change amount just make sure profit matches below ex carrot seed =70 so 70/4=17.5 so sell price=21 so if new price 100 then 100/4=25 new sell price=25+3.5
			"carrot":21, #3.5*4 profit give or take same for all maybe slightly more as it go down per item 
			"herb":47, #9.5*4- more then or close to 2.71*carrot profit
			"corn":136,   #11*4- more then 3.1*carrot profit
			"radish":338, #13*4-   3.7*carrotprfot
			"sugarcane":365, #15*4-  4.29
			"mushroom":392, #17*4   -4.86
			"wheat":395, #20*4      -5.7
			"dough":1650, #cooking so price based on item instead of seed#1400-(min395*3+300, max300*3+395)=1400-(min 1485,max1295)=min 165, max 355
			"oil":600, ### 600-136*4=600-544=156
			"sugar":1620,##1620-365*4=1620-1460=160
			"butter":6020, # 5*4+1500*4=  - less or close to 1.429 so 3.5*1.4229~5
			"cheese":2250,# milk:1500,water:300,herb:75*2=1950 if 2 milk then -profit
			"sand":50,
			"flask":110
			}
func _ready():
	pass
