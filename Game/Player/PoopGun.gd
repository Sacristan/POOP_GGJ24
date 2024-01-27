extends Node3D
class_name PoopGun

@export var projectile: PackedScene
@export var shootOrigin: Node3D

var poopPool: int = 0

signal onEjected
signal onExtracted

var fwd_dir : Vector3 :
	get:
		return shootOrigin.global_transform.basis.z

func _process(delta):
	if(Input.is_action_just_pressed("extract")):
		extract()
	elif(Input.is_action_just_pressed("eject")):
		eject()
	
func extract():
	var result := raycastTestPos(shootOrigin.global_position, fwd_dir)
	#print(result)
	
	if(result.hitEligibleTarget):
		if(result.obj is Poop):
			extractPoop(result.obj)
	
func eject():
	if(poopPool > 0):
		ejectPoop()
		onEjected.emit()

func extractPoop(obj: Poop):
	poopPool = poopPool + 1
	obj.extract(-fwd_dir)
	obj.cleanup(2)
	onExtracted.emit()

func ejectPoop():
	var poop := projectile.instantiate()
	getDetachNode().add_child(poop)
	poop.global_position = shootOrigin.global_position
	poop.global_transform.basis.z = fwd_dir
	
	poop.eject(fwd_dir)
	
	poopPool = poopPool - 1
	
func getDetachNode() -> Node3D:
	return get_tree().root.get_child(0)
	
func raycastTestPos(origin: Vector3, dir: Vector3) -> Dictionary:
	var params = PhysicsRayQueryParameters3D.new()
	params.from = origin
	params.to = origin + dir * 100
	
	#DebugDraw3D.draw_line(params.from, params.to, Color.YELLOW, 3)
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	
	var hitEligibleTarget := false
	var obj = null
	
	if result:
		#print(result.collider)
		
		hitEligibleTarget = result.collider is Poop
		obj = result.collider
		
		return { "wasHit": true, "hitEligibleTarget": hitEligibleTarget, "hitPos": result.position, "obj": obj }
		
	return { "wasHit": false, "hitEligibleTarget": hitEligibleTarget, "hitPos": Vector3.ZERO , "obj": obj }
