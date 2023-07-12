tool

extends Node2D


# Declare member variables here. Examples:
# var a = 2
export var left_wall = true
export var right_wall = true

export var ceiling = true
export var _floor = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if left_wall:
		$left_wall.show()
	else:
		$left_wall.hide()
	
	if right_wall:
		$right_wall.show()
	else:
		$right_wall.hide()

	if ceiling:
		$ceiling.show()
	else:
		$ceiling.hide()
	
	if _floor:
		$floor.show()
	else:
		$floor.hide()
