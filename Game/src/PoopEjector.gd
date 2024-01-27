extends Node3D
class_name PoopEjector

@export var projectile: PackedScene
@export var shootOrigin: Node3D
@export var projectileForce :float = 35

var fwd_dir : Vector3 :
	get:
		return shootOrigin.global_transform.basis.z

func ejectPoop():
	var poop := projectile.instantiate()
	getDetachNode().add_child(poop)
	poop.global_position = shootOrigin.global_position
	poop.global_transform.basis.z = fwd_dir
	poop.eject(fwd_dir, getProjectileForce())
	
func getDetachNode() -> Node3D:
	return get_tree().root.get_child(0)

func getProjectileForce() -> float:
	return projectileForce
