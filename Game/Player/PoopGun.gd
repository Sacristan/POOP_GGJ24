extends PoopEjector
class_name PoopGun

var poopPool: int = 0

signal onEjected
signal onExtracted

@onready var extractSFX := $"extractSFX"
@onready var ejectSFX := $"ejectSFX"

func _ready():
	Global.poopGun = self

func _process(delta):
	if(Input.is_action_just_pressed("extract")):
		extract()
	elif(Input.is_action_just_pressed("eject")):
		eject()
	
func extract():
	var result := raycastTestPos(shootOrigin.global_position, fwd_dir)
	#print(result)
	
	if(result.hitEligibleTarget):
		if(result.obj is Shit):
			extractPoop(result.obj)
			extractSFX.play()
			
		elif(result.obj is Animal):
			result.obj.add_damage(100)
	
func eject():
	if(poopPool > 0):
		ejectSFX.play()
		ejectPoop()
		onEjected.emit()

func extractPoop(obj: Shit):
	poopPool = poopPool + 1
	obj.extract(-fwd_dir, projectileForce)
	obj.cleanup(2)
	onExtracted.emit()

func ejectPoop():
	super.ejectPoop()
	poopPool = poopPool - 1
	
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
		
		hitEligibleTarget = result.collider is Shit or Animal
		obj = result.collider
		
		return { "wasHit": true, "hitEligibleTarget": hitEligibleTarget, "hitPos": result.position, "obj": obj }
		
	return { "wasHit": false, "hitEligibleTarget": hitEligibleTarget, "hitPos": Vector3.ZERO , "obj": obj }
