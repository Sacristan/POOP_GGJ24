extends Node3D
class_name GameManager

@export var fast_close := true

var currentTime = 0
var poopsies: Array = []
var poopsiesRemoved: int = 0

var totalAnimals := 0
var animalsPacified := 0

var isGameEnding:=false

func cleanPoopsies():
	poopsies = Global.clean_array(poopsies)

func _ready() -> void:
	Global.gm = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)
	
	await get_tree().physics_frame
	Global.player.onDied.connect(Global.gameLost)
	
	while(true):
		await Global.wait(1)
		Global.checkIfGameWon()

func _process(delta):
	currentTime+=delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().quit() # Quits the game
	
	if event.is_action_pressed(&"change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
