extends RigidBody3D
class_name Poop

var force := 25
@onready var timer: Timer = get_node("Timer")
@onready var area := get_node("Area3D")

func _ready():
	self.area.body_entered.connect(areaEntered)
	
func fire(dir: Vector3):
	apply_impulse(dir * force)
	
func cleanup(time: float):
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(self.queue_free)
	
func areaEntered(body):
	if(body is Player):
		queue_free()
