extends Node3D
class_name Truck

@onready var area: Area3D = $"Area3D"

func _ready():
	Global.truck = self
	area.body_entered.connect(bodyEntered)
	
func bodyEntered(body):
	print("truck " + body.name)
	if(body is Shit):
		Global.poopsiesDelivered()
		body.queue_free()
