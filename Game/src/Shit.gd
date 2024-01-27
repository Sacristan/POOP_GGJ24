extends RigidBody3D
class_name Shit

@onready var timer: Timer = $"Timer"
@onready var area :Area3D = $"Trigger"

var isExtracting := false

func _ready():
	self.area.body_entered.connect(areaEntered)

func poopOut(dir: Vector3, force: float):
	eject(dir, force)

func extract(dir: Vector3, force: float):
	isExtracting = true
	fire(dir, force)
	
func eject(dir: Vector3, force: float):
	isExtracting = false
	fire(dir, force)
	
func fire(dir: Vector3, force: float):
	apply_impulse(dir * force)
	
func cleanup(time: float):
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(self.queue_free)
	
func areaEntered(body):
	if(body is Player && isExtracting):
		queue_free()
