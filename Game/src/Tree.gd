extends Node

@onready var area := $"Area3D"

func _ready():
	self.area.body_entered.connect(areaEntered)
	
func areaEntered(body):
	if(body is Player):
		print("player entered tree "+name)
