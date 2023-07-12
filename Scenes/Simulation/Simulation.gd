extends Control




var last_load_button = 1

var last_simulation = ""
var Running_simulation_prefab = load("res://Scenes/Building.tscn")

onready var running_sim = $runnig_sim


var world_paused = false

onready var cam = $Camera2D
var cam_speed = 50




func _ready():
#	overlay.add_stat("Engine TimeScale", Engine, "get_time_scale", true)
	pass

func _process(_delta):
	update_cam_movement(Input)
	zoom_in_out()
	slow_fast_time()



func zoom_in_out():
	if Input.is_action_pressed("zoom_in"):
		cam.zoom -= Vector2(0.03, 0.03)
	elif Input.is_action_pressed("zoom_out"):
		cam.zoom += Vector2(0.03, 0.03)



func slow_fast_time():
	if Input.is_key_pressed(KEY_1):
		Engine.time_scale -= 0.1
	elif Input.is_key_pressed(KEY_2):
		Engine.time_scale += 0.1


func update_cam_movement(event):
	if event.is_action_pressed("ui_left"):
		cam.position.x -= cam_speed# * delta
	elif event.is_action_pressed("ui_right"):
		cam.position.x += cam_speed# * delta
	
	if event.is_action_pressed("ui_up"):
		cam.position.y -= cam_speed
	if event.is_action_pressed("ui_down"):
		cam.position.y += cam_speed


func _input(event):
	if event is InputEventKey:
		pause_and_play(event)
		reload_scene(event)
		reload_running_sim(event)
		running_simulation_debug(event)


# Pausing
func pause_and_play(event):
	if event.is_action_pressed("ui_select") and !world_paused:
		get_tree().paused = true
		world_paused = true
	elif event.is_action_pressed("ui_select") and world_paused:
		get_tree().paused = false
		world_paused = false


# reload_running_sim because using the tree reload will also reload the simulation node having the rumminig simulstion node
func reload_running_sim(event):
	if event.is_action_pressed("reload"):
#		var running_simulation_instance =  Running_simulation_prefab.instance()
		var running_simulation_instance =  load(running_sim.get_child(0).filename).instance()
		
		running_sim.get_child(0).queue_free()
		running_sim.add_child(running_simulation_instance)


# Reload running scene ie: simulation scene
func reload_scene(event):
	if event.is_action_pressed("reload_scene"):
		var _eror = get_tree().reload_current_scene()
		Engine.time_scale = 1


# Load a scene form file dialog
func _on_Button_pressed(extra_arg_0):
	last_load_button = extra_arg_0 # update the button pressed script globally
	var button_label = $CanvasLayer.get_child(extra_arg_0-1)
	button_label.release_focus()
	button_label.get_node("Button").release_focus()
	
#	$CanvasLayer/FileDialog.show() # using show, will not refresh the path
	$CanvasLayer/FileDialog.popup()
	
	# Need to connect this manually to sent an argument to it.
	if not $CanvasLayer/FileDialog.is_connected("file_selected", self, "_on_FileDialog_file_selected"):
		var _eror = $CanvasLayer/FileDialog.connect("file_selected", self, "_on_FileDialog_file_selected")
#		$CanvasLayer/FileDialog.connect("file_selected", $CanvasLayer/FileDialog, "_on_FileDialog_file_selected", [button_label])
	


func _on_FileDialog_file_selected(path):
	var the_label = $CanvasLayer.get_child(last_load_button-1)
	the_label.text = path
	
	var New_building = load(path)
	var new_building_instance = New_building.instance()
#	var new_building = preload("/storage/emulated/0/Download/GODOT creations New/Elevator simulator/Scenes/Building_samples/Building_sample1.tscn")
	
	running_sim.get_child(0).queue_free()
	running_sim.add_child(new_building_instance)


# Open from Label directly using its child Button
func _on_Button2_pressed(extra_arg_0):
	var the_label = $CanvasLayer.get_child(extra_arg_0-1)
	var path = the_label.text
	the_label.get_node("Button2").release_focus()
	
	if path == "":
		return
	
	var New_building = load(path)
	var new_building_instance = New_building.instance()
#	var new_building = preload("/storage/emulated/0/Download/GODOT creations New/Elevator simulator/Scenes/Building_samples/Building_sample1.tscn")
	
	running_sim.get_child(0).queue_free()
	running_sim.add_child(new_building_instance)


# Using "Tab" for "debug_1"
func running_simulation_debug(event):
	if running_sim.get_child(0):
		if running_sim.get_child(0).has_node("debug_overlay_building"):
			if event.is_action_pressed("debug_1") and running_sim.get_child(0).get_node("debug_overlay_building").get_node("Label").visible:
				running_sim.get_child(0).get_node("debug_overlay_building").get_node("Label").hide()
			elif event.is_action_pressed("debug_1") and !running_sim.get_child(0).get_node("debug_overlay_building").get_node("Label").visible:
				running_sim.get_child(0).get_node("debug_overlay_building").get_node("Label").show()
