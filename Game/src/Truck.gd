extends Node3D
class_name Truck

@onready var area: Area3D = $"Area3D"

func _ready():
	Global.truck = self
	area.body_entered.connect(bodyEntered)
	
func bodyEntered(body):
	if(body is Shit):
		Global.poopsiesDelivered(body)
		
		await get_tree().physics_frame
		body.queue_free()
