extends Node3D


@onready var playButton: Button = $"MenuUI/Control/VBoxContainer/Play"
@onready var quitButton: Button = $"MenuUI/Control/VBoxContainer/Quit"

func _ready():
	playButton.pressed.connect(Global.launchGame)
	quitButton.pressed.connect(Global.quitGame)
