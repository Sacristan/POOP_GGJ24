extends Node

var currentTime = 0
var player: Player
var poopGun: PoopGun

func _process(delta):
	currentTime+=delta

func retryGame():
	get_tree().reload_current_scene()
	
func quitGame():
	get_tree().quit()
	
func enableCursor(flag):
	if(flag):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func getCurrentSceneName():
	return get_tree().get_current_scene().get_name()

func wait(time):
	return get_tree().create_timer(time, false)
