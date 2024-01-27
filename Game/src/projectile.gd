extends RigidBody3D

#@onready var rigidbody: RigidBody3D = get_node("RigidBody3D")
var force := 25
@onready var timer: Timer = get_node("Timer")

func _ready():
	timer.start()
	timer.timeout.connect(self.queue_free)

func fire(dir: Vector3):
	apply_impulse(dir * force)
