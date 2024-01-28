extends Node3D
class_name Truck

@onready var area: Area3D = $"Area3D"
@onready var deliverSFX: = $"ShitDeliverSFX"

func _ready():
	Global.truck = self
	area.body_entered.connect(bodyEntered)
	
func bodyEntered(body):
	if(body is Shit):
		Global.poopsiesDelivered(body)
		
		deliverSFX.pitch_scale = randf_range(0.5, 1.5)
		deliverSFX.play()
		
		await get_tree().physics_frame
		body.queue_free()
