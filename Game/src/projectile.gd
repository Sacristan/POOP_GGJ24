extends RigidBody3D

#@onready var rigidbody: RigidBody3D = get_node("RigidBody3D")
var force := 25

func fire(dir: Vector3):
	apply_impulse(dir * force)
