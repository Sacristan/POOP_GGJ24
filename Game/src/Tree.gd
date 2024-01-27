extends Node

@export var animationPlayer: AnimationPlayer
@export var animationNameOnPlayerPresence: String

@onready var area := $"Area3D"

func _ready():
	self.area.body_entered.connect(areaEntered)
	
func areaEntered(body):
	if(body is Player):
		handlePlayer()

func handlePlayer():
	print("player entered tree "+name)
	
	if(animationPlayer):
		animationPlayer.play(animationNameOnPlayerPresence)
