extends Control

var briefingLapsed = 0
const TypeSpeed = 0.1

@onready var briefingText: RichTextLabel = $briefingtext

func _ready():
	briefingLapsed = 0
	briefingText.visible_characters = 0
	
	set_physics_process(false)
	
	await Global.wait(1)
	set_physics_process(true)

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		Global.launchGame()

func _physics_process(delta):
	briefingLapsed += delta
	briefingText.visible_characters = briefingLapsed/TypeSpeed
