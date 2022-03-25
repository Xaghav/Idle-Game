extends Node2D
#### node will save all its var in dict and then we will save the dictionary!! 
### i need to create diff sav_path aka diff file for diff node so its easier to store info from each node with their unieque dict + they wont overridde!!! and laod to their needed file!! unless i make huge dictionary that store var from ea node!!!! 
### i could have 1 big diction!! which store dictorinary from their node!! and only load their node that way
##ex dict info= {node1:{"a":10, "b"=12}, node2:{....}} (we have to add all the stuff and node in dict first) ==> update inf[node1]={"a":12,"b"=13}  (again we have to add all node1 info so when we update it overide the old one and store all info since its overriding we have tell also inculde things that stayed the same)
## problem is it will save the node but also override and make other node empty so if we could find out file exist!!! and update on that it be much easier!!!
var save_path="user://charactercustomization.save" ### file name will be save!!!

func save_game(node,info):
	var data={} ## info= dictonary and convert the value to str so it cansave !!!!!!
	var save_file=File.new()   ##save_game is just instance that save data to save_path!!!
	if save_file.file_exists(save_path): ## check if file exist then just load the data!!! so we can update
		data=load_game()
	data[node]=info
	var error=save_file.open(save_path,File.WRITE)   ## after file open it will say false for file exist!!!!
	if error== OK:
		save_file.store_var(data)
		save_file.close()
	else:
		print("Error:"+str(error)+".can not save the file")
		save_file.close()

func load_game():
	var load_file=File.new()  #load game is just instance that will be storing file data in save_path
	var content
	if load_file.file_exists(save_path):
		var error=load_file.open(save_path,File.READ)
		if error== OK:
			#print(load_file.get_as_text())
			content=load_file.get_var()
			load_file.close()
		else:
			print("file did not load.error:"+str(error))
			load_file.closed()
	else:
		print("there no saved file to load")
		return {"empty":"empty"}
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	var a={"bob":10,"jo":14}
#	var b={"aa":20,"gi":17}
#
#	save_game("node2",a)
#	save_game("node1",b)
#	var c=load_game()
#	print("gamedata",c)
#	pass


 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass
