extends Node3D

@export var projectile: PackedScene
@export var shootOrigin: Node3D

var poopPool: Array = []

var fwd_dir : Vector3 :
	get:
		return shootOrigin.global_transform.basis.z

func _process(delta):
	if(Input.is_action_just_pressed("extract")):
		extract()
	elif(Input.is_action_just_pressed("eject")):
		eject()
	
func extract():
	print("extract")
	var result := raycastTestPos(shootOrigin.global_position, fwd_dir)
	print(result)
	
	if(result.hitEligibleTarget):
		if(result.obj is Poop):
			extractPoop(result.obj)
	
func eject():
	if(not poopPool.is_empty()):
		ejectPoop()

func extractPoop(obj: Poop):
	obj.fire(-fwd_dir)

func ejectPoop():
	var bullet := projectile.instantiate()
	getDetachNode().add_child(bullet)
	bullet.global_position = shootOrigin.global_position
	bullet.global_transform.basis.z = fwd_dir
	
	bullet.fire(fwd_dir)
	#bullet.fire(Vector3.FORWARD)
	
func getDetachNode() -> Node3D:
	return get_tree().root.get_child(0)
	
func raycastTestPos(origin: Vector3, dir: Vector3) -> Dictionary:
	var params = PhysicsRayQueryParameters3D.new()
	params.from = origin
	params.to = origin + dir * 100
	
	DebugDraw3D.draw_line(params.from, params.to, Color.YELLOW, 3)
	
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	
	var hitEligibleTarget := false
	var obj = null
	
	if result:
		print(result.collider)
		
		hitEligibleTarget = result.collider is Poop
		obj = result.collider
		
		return { "wasHit": true, "hitEligibleTarget": hitEligibleTarget, "hitPos": result.position, "obj": obj }
		
	return { "wasHit": false, "hitEligibleTarget": hitEligibleTarget, "hitPos": Vector3.ZERO , "obj": obj }
