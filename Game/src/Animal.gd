extends PoopEjector
class_name Animal

@export var minPoopDelayTime: float = 1
@export var maxPoopDelayTime: float = 3

const minDist = 3
const maxDist = 15

signal reachedDestination

var targetPos := Vector3.ZERO
var move := false

@export var speed: float = 5 
@onready var body: CharacterBody3D = $"."
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

const closeEnoughDist := 1

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	#call_deferred("actor_setup")
	walkLoop()
	poopLoop()

func _physics_process(delta):
	if(move):
		print(navigation_agent.get_next_path_position())
			
		print(navigation_agent)
		
		if navigation_agent.is_navigation_finished():
			return

		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()

		body.velocity = current_agent_position.direction_to(next_path_position) * speed
		body.move_and_slide()
		
		if(global_position.distance_to(targetPos) < closeEnoughDist):
			reachedDestination.emit()
	
func updateNavAgent():
	navigation_agent.set_target_position(targetPos)
	
#func _physics_process(delta: float) -> void:
	#if(move):
		#var direction = global_position.direction_to(targetPos)
		#direction.y = 0
		#
		#body.velocity = direction * speed
		#body.move_and_slide()
		#
		#if(global_position.distance_to(targetPos) < closeEnoughDist):
			#reachedDestination.emit()

func walkLoop():
	await get_tree().physics_frame
	
	var originalHeight = global_position.y
	
	while(true):
		await wait(1).timeout
		
		targetPos = getWanderPos()
		
		print(targetPos)
		updateNavAgent()
		
		move = true
		await reachedDestination
		move = false
		print("reachedDestination")

func poopLoop():
	while(true):
		await wait(poopTimeout()).timeout
		poop()

func poop():
	ejectPoop()

func poopTimeout():
	randomize()
	return randf_range(minPoopDelayTime, maxPoopDelayTime)

func getProjectileForce():
	randomize()
	return super.getProjectileForce() * randf_range(0.5, 1)

func wait(time):
	return get_tree().create_timer(time, false)
	
func getWanderPos():	
	var result = Vector3.ZERO
	
	var tries = 0
	
	while(true):
		tries+=1
		
		result = get_random_pos_in_sphere(maxDist)
		result.y = 0
		result += global_position
		
		if(global_position.distance_to(result) > minDist):
			return result;
		
		if(tries > 30):
			return result
		
func get_random_pos_in_sphere (radius : float) -> Vector3:
	randomize()
	
	var x1 = randf_range (-1, 1)
	var x2 = randf_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = randf_range (-1, 1)
		x2 = randf_range (-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
		2 * x1 * sqrt (1 - x1*x1 - x2*x2),
		2 * x2 * sqrt (1 - x1*x1 - x2*x2),
		1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere * randf_range (0, radius)
