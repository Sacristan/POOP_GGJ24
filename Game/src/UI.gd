extends Control

@export var player: Player
@export var poopGun: PoopGun

@onready var poopLbl: Label = $"Poopies"
@onready var damageEffect = $damageEffect

const DamageIndicationAppearTime = 0.5
const DamageIndicationDissapearTime = 5
var lastTimeDamageReceived = 0
var appearTimer = 0

func _ready():
	poopGun.onEjected.connect(updatePoopLabel)
	poopGun.onExtracted.connect(updatePoopLabel)
	
	player.onDamageReceived.connect(onReceivedDamage)
	player.onDied.connect(onGameOver)
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
	
func updatePoopLabel():
	poopLbl.text = "Poop: " + str(poopGun.poopPool)
