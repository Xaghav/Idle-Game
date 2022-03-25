extends Node2D
onready var popupmessage=get_node("PopupDialog")
onready var popuplabel=get_node("PopupDialog/Label")
onready var buybutton=get_node("PanelContainer/Panel/GridContainer/CenterContainer/Button")
onready var label=get_node("PanelContainer/Panel/GridContainer/Label")
var payment=null
var test_item_purchase_token = null
var itembought=null

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)

		payment.startConnection()
	else:
		buybutton.disabled=true
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")


func _on_connected():
	payment.querySkuDetails(["gold1"], "inapp") # ask google detail about these item# "subs" for subscriptions
	var query = payment.queryPurchases("inapp") # Or "subs" for subscriptions
	if query.status == OK:
		for purchase in query.purchases:
			##########
#			if purchase.sku =="nonconsumable item id":
#				# give the item
#				if !purchase.is_acknowledged:
#					payment.acknowledgePurchase(purchase.purchase_token)
#			if purchase.sku =="gold1":
#				if !purchase.is_acknowledged:
#					payment.consumePurchase(purchase.purchase_token)
#######combined just have to write for nonconsumable
			if purchase.sku=="gold1" and !purchase.is_acknowledged :
				itembought="gold1"
				payment.consumePurchase(purchase.purchase_token)
#	 			#payment.acknowledgePurchase(purchase.purchase_token)
	else:
		print("purchase query failed",query.status)

func _on_sku_details_query_completed(sku_details):
	for available_sku in sku_details:
		if available_sku.sku=="gold1":
			label.text="Item: Gold"+"\n Description: "+String(available_sku.description)+"\n Price: "+String(available_sku.original_price)
		

####no need will check on purchases_updated
#func buy(itembought:String):
#	var query = payment.queryPurchases("inapp") # Or "subs" for subscriptions
#	if query.status == OK:
#		for purchase in query.purchases:
#			if purchase.sku == itembought:
#				if !purchase.is_acknowledged:
#					payment.consumePurchase(purchase.purchase_token)
					# Check the _on_purchase_consumed callback and give the user what they bought

func  _on_purchases_updated(purchases):
	for purchase in purchases:
		if purchase.sku =="nonconsumable item id":
			# give the item
			if !purchase.is_acknowledged:
				payment.acknowledgePurchase(purchase.purchase_token)
		if purchase.sku =="gold1":
			if !purchase.is_acknowledged:
				itembought="gold1"
				payment.consumePurchase(purchase.purchase_token)
#	if purchases.size() > 0:
#		test_item_purchase_token = purchases[purchases.size() - 1].purchase_token

func _on_disconnected():
	
	popupmessage.popup()
	popupmessage.window_title="GodotGooglePlayBilling disconnected."
	popuplabel.text="Will try to reconnect in 10s..."
	yield(get_tree().create_timer(10), "timeout")
	payment.startConnection()

func _on_buy_gold():
	
	#payment.consumePurchase("gold")
	var response=payment.purchase("gold1") #product id, also if credit card is slow it will just take few min and _on_purchse_consumpot_error will come!!!!
	if response.status !=OK:
		label.text=String(response.response_code)+String(response.debug_message)
		
	
#	buy("gold")#no need it will check using on_purchses_updated # isntead of gold need to put gold productid
func _on_purchase_consumed(item): # item= token id
	if itembought=="gold1":
		popupmessage.popup()
		popupmessage.window_title="Payment confirmed"#str(item)
		popuplabel.text="item bought 55,000 Gold"#+str(item)
		get_node("../Panel/Label").text=String(int(get_node("../Panel/Label").text)+55000)
func _on_purchase_consumption_error(id,debug,token):
	popupmessage.popup()
	popupmessage.window_title="Purchase in process" #str(id)+" , "+str(debug)+" , "+str(token) # debug is all i need it tell whats wrong
	popuplabel.text="Purchase request has occurred but \n the payment has not been confirmed yet." + str(id)+" "+str(debug)
	
