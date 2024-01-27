extends Node

var currentTime = 0
var player: Player
var poopGun: PoopGun
var truck: Truck

var poopsies: Array = []
var poopsiesRemoved: int = 0

var totalAnimals := 0
var animalsPacified := 0

signal onPoopsiesChanged
signal onAnimalPacified

func _process(delta):
	currentTime+=delta

func registerAnimal(animal: Animal):
	totalAnimals += 1

func retryGame():
	get_tree().reload_current_scene()

func poopsiesDelivered(poop: Shit):
	poopsiesRemoved +=1
	poopsies.erase(poop)
	onPoopsiesChanged.emit()

func poopRemoved(poop: Shit):
	poopsies.erase(poop)
	onPoopsiesChanged.emit()
	
func poopSpawned(poop: Shit):
	poopsies.append(poop)
	onPoopsiesChanged.emit()

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
	return get_tree().create_timer(time, false).timeout
