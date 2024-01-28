extends Node3D

@onready var playButton: Button = $"MenuUI/Control/VBoxContainer/Play"
@onready var quitButton: Button = $"MenuUI/Control/VBoxContainer/Quit"

func _ready():
	playButton.pressed.connect(Global.launchBriefing)
	quitButton.pressed.connect(Global.quitGame)
