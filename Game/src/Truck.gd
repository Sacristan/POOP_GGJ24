extends Node3D
class_name Truck

@onready var area: Area3D = $"Area3D"
@onready var deliverSFX: = $"ShitDeliverSFX"
@onready var shit:= $"PileOfShit/DeleteNow/PileOfShitForCar"

func _ready():
	Global.truck = self
	area.body_entered.connect(bodyEntered)
	
func bodyEntered(body):
	if(body is Shit):
		Global.poopsiesDelivered(body)
		
		deliverSFX.pitch_scale = randf_range(0.5, 1.5)
		deliverSFX.play()
		
		updateShapes()
		
		await get_tree().physics_frame
		body.queue_free()
		
func updateShapes():
	var shitProgress: float = inverse_lerp(0, 100, Global.gm.poopsiesRemoved)
	
	shit.set_blend_shape_value(0, lerp(-1, 1, shitProgress))
	shit.set_blend_shape_value(1, lerp(1, -1, shitProgress))
