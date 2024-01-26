@tool
extends MeshInstance3D
class_name BrushIndicator 

const Brush = preload("res://addons/object_brush/Brush.gd")

signal onSpawn
signal onDeath

func _enter_tree():
	print("indicator _enter_tree")
	self.onSpawn.emit()

func _exit_tree():
	print("indicator _exit_tree")
	self.onDeath.emit()

func kill():
	self.print_tree_pretty()
#	self.reparent(get_tree().root)
#	self.queue_free()
	
	self.call_deferred("free")
	print("kill req")

func update(pos: Vector3, brush: Brush):
	self.position = pos + transform.basis.y * brush.indicatorHeight
	
	mesh.height = brush.indicatorHeight
	mesh.top_radius = brush.brushSize
	mesh.bottom_radius = brush.brushSize
