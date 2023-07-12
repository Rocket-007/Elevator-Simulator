extends Node2D



export var floors = 0 # no of floors in the building
var elevator_array = [] # this holds all elevators in the building
var elevator_array_size = 0

var has_exec_get_elevators = false

var People = 0

var wait_time_array = {}
var wait_time_average  = 0

var simulation_done = false
var simulation_time = 0

var  simulation_time_scale = Engine.time_scale



# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = $debug_overlay_building
	overlay.add_stat("Floors", self, "floors", false)
	overlay.add_stat("People", self, "People", false)
	overlay.add_stat("elevator_array_size", self, "elevator_array_size", false)
	overlay.add_stat("wait_time_average", self, "wait_time_average", false)
	overlay.add_stat("Simulation_done", self, "simulation_done", false)
	overlay.add_stat("Simulation_done_time", self, "simulation_time", false)
	overlay.add_stat("Simulation_time_scale", self, "simulation_time_scale", false)
	
	for v in get_children():
		if v.is_in_group("Elevator"):
			elevator_array.append(v)
			
	for v in get_children():
		if v.is_in_group("Person"):
			People += 1
			
	elevator_array_size = elevator_array.size()




func _process(delta):
	# might need to update the elevators in our array on runtime
#	if !has_exec_get_elevators:
#		for v in get_children():
#			if v.is_in_group("Elevator"):
#				elevator_array.append(v)
#				print("here")
#		if elevator_array.size() > 0:
#			has_exec_get_elevators = true
	
	
	# wait time average calculation
	if wait_time_array.size() > 0: 
		var wait_time_sum = 0
		for v in wait_time_array.values():
			wait_time_sum += v.wait_time
		
		wait_time_average = wait_time_sum / wait_time_array.size()
	
#	checks
	check_sim_done()
	check_sim_done_time(delta)
	
	simulation_time_scale = Engine.time_scale


func check_sim_done():
	var yes1 = 0
	for v in get_children():
		if v.is_in_group("Person"):
			if v.current_floor == v.destination_floor:
				
				yes1 += 1
				if yes1 == People:
					simulation_done = true
			else:
				break


func check_sim_done_time(delta):
	if !simulation_done:
		simulation_time += delta
