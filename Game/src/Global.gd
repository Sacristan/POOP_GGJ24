extends Node

var gm: GameManager
var player: Player
var poopGun: PoopGun
var truck: Truck

signal onPoopsiesChanged
signal onAnimalPacified

signal onGameLost
signal onGameWon

var freezeGameState: bool:
	get:
		return player.isDead || gm.isGameEnding

func checkIfGameWon():
	if(!gm.isGameEnding && hasGameBeenWon()):
		gm.isGameEnding = true
		print("gameWon")
		onGameWon.emit()
		await Global.wait(2)
		Global.retryGame()

func gameLost():
	if(!gm.isGameEnding):
		gm.isGameEnding = true
		print("gameLost")
		onGameLost.emit()
		await Global.wait(2)
		Global.retryGame()

func hasGameBeenWon() -> bool:
	var allAnimalsPacified := gm.animalsPacified >= gm.totalAnimals
	var noPoopsiesInForest := gm.poopsies.size() <= 0
	var noPoopInStash := poopGun.poopPool <= 0
	
	return allAnimalsPacified && noPoopsiesInForest && noPoopInStash

func animalPacified(animal: Animal):
	gm.animalsPacified+=1
	onAnimalPacified.emit()
	checkIfGameWon()

func registerAnimal(animal: Animal):
	gm.totalAnimals += 1

func retryGame():
	get_tree().reload_current_scene()

func poopsiesDelivered(poop: Shit):
	gm.poopsiesRemoved +=1
	gm.poopsies.erase(poop)
	gm.cleanPoopsies()
	
	onPoopsiesChanged.emit()
	checkIfGameWon()

func poopRemoved(poop: Shit):
	gm.poopsies.erase(poop)
	gm.cleanPoopsies()
	
	onPoopsiesChanged.emit()
	
func poopSpawned(poop: Shit):
	gm.poopsies.append(poop)
	gm.cleanPoopsies()
	onPoopsiesChanged.emit()

const gameScenePath = "res://Levels/Main/Main.tscn"
const menuScenePath = "res://scenes/menu.tscn"
const briefingScenePath = "res://scenes/briefing.tscn"

func launchBriefing():
	get_tree().change_scene_to_file(briefingScenePath)
	
func launchGame():
	get_tree().change_scene_to_file(gameScenePath)

func launchMenu():
	get_tree().change_scene_to_file(menuScenePath)

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
	
func clean_array(dirty_array: Array) -> Array:
	var cleaned_array = []
	for item in dirty_array:
		if is_instance_valid(item):
			cleaned_array.push_back(item)
	return cleaned_array
