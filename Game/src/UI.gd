extends Control

@export var poopGun: PoopGun
@onready var poopLbl: Label = $"Poopies"

func _ready():
	poopGun.onEjected.connect(updatePoopLabel)
	poopGun.onExtracted.connect(updatePoopLabel)
	
func updatePoopLabel():
	poopLbl.text = "Poop: " + str(poopGun.poopPool)
