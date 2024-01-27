extends Node

@export var animationPlayer: AnimationPlayer
@export var animationNameOnPlayerPresence: String

@onready var area := $"Area3D"

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
	
	if(animationPlayer):
		#animationPlayer.speed_scale = 1
		animationPlayer.play(animationNameOnPlayerPresence)

	player.add_damage(10)

func handlePlayerExited(player):
	print("player exited tree "+name)
	
	if(animationPlayer):
		#animationPlayer.speed_scale = -1
		animationPlayer.play_backwards(animationNameOnPlayerPresence)
