extends Area3D


func _ready():
	body_entered.connect(bodyEntered)

func bodyEntered(body):
	if(body is Player):
		Global.gameLost()
	elif(body is Shit):
		Global.poopsiesDelivered(body)
