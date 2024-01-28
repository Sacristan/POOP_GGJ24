extends Control

@export var player: Player
@export var poopGun: PoopGun
@export var panelWonColor: Color
@export var panelLostColor: Color

@onready var poopStashed: Label = $"Control2/HBoxContainer/PoopStashed"
@onready var poopRemaining: Label = $"Control2/HBoxContainer/PoopRemaining"

@onready var animalsLbl: Label = $"Control/HBoxContainer/Animals"
@onready var healthLbl: Label = $"Control/HBoxContainer/Health"

@onready var damageEffect = $damageEffect

@onready var gameOverColorRect: ColorRect = $Panel_GameOver
@onready var gameOverLabel: Label = $Panel_GameOver/Label

const DamageIndicationAppearTime = 0.5
const DamageIndicationDissapearTime = 5
var lastTimeDamageReceived = 0
var appearTimer = 0

func gameWon():
	gameOverColorRect.visible = true
	gameOverColorRect.color = panelWonColor
	gameOverLabel.text = "Game Won!"

func gameLost():
	gameOverColorRect.visible = true
	gameOverColorRect.color = panelLostColor
	gameOverLabel.text = "Game Lost!"
		

func _ready():
	player.onDamageReceived.connect(onReceivedDamage)
	player.onDied.connect(onGameOver)
	
	Global.onPoopsiesChanged.connect(updatePoopLabel)
	Global.onAnimalPacified.connect(updateAnimalsLabel)
	
	Global.onGameWon.connect(gameWon)
	Global.onGameLost.connect(gameLost)
	
	await Global.wait(0.1)
	
	updateHealth()
	updateAnimalsLabel()
	#Global.player.connect("onDied", self, "gameOver")

func _process(delta):
	var timeDelta = Global.currentTime - lastTimeDamageReceived
	var t
	var alpha = 0
	
	if timeDelta < DamageIndicationAppearTime:
		appearTimer+=delta
		t = appearTimer / DamageIndicationAppearTime
		alpha = lerp(get_damage_alpha(), 0.5, t)
		update_damage_alpha(alpha)
		
	elif timeDelta < DamageIndicationDissapearTime:
		t = timeDelta / (DamageIndicationDissapearTime - DamageIndicationAppearTime)
		alpha = lerp(get_damage_alpha(), 0.0, t)
		update_damage_alpha(alpha)
				
func update_damage_alpha(alpha):
	damageEffect.material.set_shader_parameter("Alpha", alpha)
	
func get_damage_alpha() -> float:
	return damageEffect.material.get_shader_parameter("Alpha")

func onGameOver():
	pass

func onReceivedDamage(health):
	lastTimeDamageReceived = Global.currentTime
	set_process(true)
	appearTimer = 0
	updateHealth()

func updateHealth():
	healthLbl.text = "Health: "+ str(Global.player.health)

func updatePoopLabel():
	poopStashed.text = "Stashed: " + str(poopGun.poopPool)
	#poopDelivered.text = "Delivered: " + str(Global.poopsiesRemoved)
	poopRemaining.text = "Remaining: " + str(Global.poopsies.size())

func updateAnimalsLabel():
	animalsLbl.text = "Animals: %d/%d"%[Global.animalsPacified,Global.totalAnimals]
