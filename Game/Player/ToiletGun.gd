extends Node3D

@export var projectile: PackedScene
@export var shootOrigin: Node3D

func _process(delta):
	if(Input.is_action_just_pressed("shoot")):
		spawnBullet()
	
func spawnBullet():
	var bullet := projectile.instantiate()
	getDetachNode().add_child(bullet)
	bullet.global_position = shootOrigin.global_position
	bullet.global_transform.basis.z = shootOrigin.global_transform.basis.z
	
	bullet.fire(shootOrigin.global_transform.basis.z)
	#bullet.fire(Vector3.FORWARD)
	

func getDetachNode() -> Node3D:
	return get_tree().root.get_child(0)
