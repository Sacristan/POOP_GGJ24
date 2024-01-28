extends Node

@export var animationPlayer: AnimationPlayer
@export var animationNameOnPlayerPresence: String
@export var damageDelay: float = 1.5
@export var damageOnAreaEnter: float = 10

@onready var area := $"Area3D"

@onready var playerEnterSFX: AudioStreamPlayer3D = $"playerEnterSFX"
@onready var attackEnterSFX: AudioStreamPlayer3D = $"attackEnterSFX"

var playerInArea := false

func _ready():
	self.area.body_entered.connect(areaEntered)
	self.area.body_exited.connect(areaExited)
	
func areaEntered(body):
	if(body is Player):
		handlePlayerEntered(body)
		
func areaExited(body):
	if(body is Player):
		handlePlayerExited(body)

func handlePlayerEntered(player):
	print("player entered tree "+name)
	
	playerInArea = true
	
	if(playerEnterSFX):
		playerEnterSFX.play()
	
	if(animationPlayer):
		#animationPlayer.speed_scale = 1
		animationPlayer.play(animationNameOnPlayerPresence)
		await Global.wait(damageDelay)
		
		if(playerInArea):
			player.add_damage(damageOnAreaEnter)
			
			if(attackEnterSFX):
				attackEnterSFX.play()

func handlePlayerExited(player):
	print("player exited tree "+name)
	
	playerInArea = false
	
	if(animationPlayer):
		#animationPlayer.speed_scale = -1
		animationPlayer.play_backwards(animationNameOnPlayerPresence)
