extends RigidBody3D
class_name Poop

var force := 25
@onready var timer: Timer = $"Timer"
@onready var area :Area3D = $"Trigger"

var isExtracting := false

func _ready():
	self.area.body_entered.connect(areaEntered)

func extract(dir: Vector3):
	isExtracting = true
	fire(dir)
	
func eject(dir: Vector3):
	isExtracting = false
	fire(dir)
	
func fire(dir: Vector3):
	apply_impulse(dir * force)
	
func cleanup(time: float):
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(self.queue_free)
	
func areaEntered(body):
	if(body is Player && isExtracting):
		queue_free()
