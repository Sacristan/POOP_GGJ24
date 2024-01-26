@tool
extends Node3D
class_name Brush

@export_category("Brush Settings")
@export var brushSize : float = 1
@export var brushDensity : int = 10
@export var useSurfaceNormal := true

@export_category("Paintable Settings")
@export var paintableObject: PackedScene
#@export_group("Paintable size")
@export var minSize: float = 0.8
@export var maxSize: float = 1

@export_group("Random Rot")
@export var randomRotMin := Vector3.ZERO
@export var randomRotMax := Vector3.ZERO

const indicatorHeight := 0.25

var cursorPos: Vector3

func getRandomSize():
	return randf_range(minSize, maxSize)
	
func getRotation():
	var x = randf_range(deg_to_rad(randomRotMin.x), deg_to_rad(randomRotMax.x))
	var y = randf_range(deg_to_rad(randomRotMin.y), deg_to_rad(randomRotMax.y))
	var z = randf_range(deg_to_rad(randomRotMin.z), deg_to_rad(randomRotMax.z))
	
	return Vector3(x, y, z)
