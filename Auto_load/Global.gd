extends Node




#var world_paused = false




#func _input(event):
#	if event is InputEventKey:
#		if event.is_action_pressed("ui_select") and !world_paused:
#			get_tree().paused = true
#			world_paused = true
##			print("1")
##		elif event.is_action_pressed("ui_select"):
#		elif event.is_action_pressed("ui_select") and world_paused:
#			get_tree().paused = false
#			world_paused = false
##			print("2")
