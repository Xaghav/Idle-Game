extends Node2D
onready var timernode=get_node("Timer")
var iap
func on_purchase_pressed(my_product:String):### connect buy button that emit product_id and my_product(product being purchased in that product id)!!!
	var result = iap.purchase( { "product_id": my_product } )
	if result == OK:# now it will be added to pending event!!! so we have to run check_event
		timernode.start()
		#animation.play("busy") # show the "waiting for response" animation

	else:
		print("error")# maybe no internet connection, API incorrectly configured, etc

# put this on a 1 second timer or something # right now i set where it check after purchase but i should set where it just check every sec in case of error or anything 
func check_events():
	while iap.get_pending_event_count() > 0:
		var event = iap.pop_pending_event()# first event/queue added from purchase
		if event.type == "purchase":
			if event.result == "ok":
				show_success(event.product_id) # have to check if the event would auto remove or i have to remove from the list
			else:
				print(event.result) # error
			if iap.get_pending_event_count()==0:
				timernode.stop() # also stop waiting animation if its playing
				### also stop animation here
func show_success(productId):
	iap.finish_transaction(productId)# we take the productid and see what item it is and add to player inventory and save the game!!!
	pass # add the product to player inv 
func _on_Timer_timeout():
	check_events()

func _ready():
	if Engine.get_singleton("InAppStore"):
		iap=Engine.get_singleton("InAppStore")
	else:
		print("iOS IAP plugin is not exported.")
