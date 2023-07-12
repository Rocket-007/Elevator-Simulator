extends Node2D




export var floors : int

var mode = 1

var height = 227
var current_floor = 0
var vertical_speed = 320 # 10s per floor

var passengers = 0 # how many people are in me now!! 
var max_passengers  = 9#16#8

#var door_open_time = 3

var has_exec_stopping = false
var stopped = false
var stopped_time = 1.3
var stopped_time_counter = 0
#var stopping

var going_up = false
var going_down = false
#var pausing = false

#var landing_call
#var car_call

#var data_file =[{"starting_floor":0, "destination_floor":3},]

var moving_index = 0
var movement_path = [] # this is the movement path the elevator takes
#var movement_path = [0, 1, 2, 1, 2, 1, 2, 1, 0, 1,]
# procedurally added paths to the movement path
var temp_movement_path = []

var available_slots = [
	[0,0,0],
	[0,0,0],
	[0,0,0],
#	[0,0,0,0]
]

var has_exec_zig_elevator_movement_path = false # for zig zag parttern


func generate_up_to_down_path_1(num):
	for i in range(floors+1):
		temp_movement_path.append(i)
		
	var ii = temp_movement_path.size() - 2
	while ii > 0:
		temp_movement_path.append(ii)
		ii -= 1
	
	for _i in range(num):
		movement_path.append_array(temp_movement_path)



func _ready():
	#	inherit floors from parent abeg
	if "floors" in get_parent():
		floors = get_parent().floors
		
	# continous generated up to down motion 
	# 100 times!!1
	generate_up_to_down_path_1(100)


# In case of different elevators present in the building, 
#this makes them move in a zig zag manner
func zig_elevator_movement_path():
	if "elevator_array" in get_parent():
		if self in get_parent().elevator_array and not has_exec_zig_elevator_movement_path:
			var elevator_array_index = get_parent().elevator_array.find(self)
			
			for i in elevator_array_index:
				movement_path.insert(0, 0) # makes the elevator wait propotionally to its the elevator_array_i
			going_up = true
			has_exec_zig_elevator_movement_path = true
			prints(movement_path[0], movement_path[1], movement_path[2], movement_path[3], movement_path[4], movement_path[5], movement_path[6])



func floor_to_y(_floor):
	return (floors*height) - (_floor*height)


func moving(delta):
	# if we have reached what is currently on the movement table
	if current_floor == movement_path[moving_index]:
		# Dont exceed tables or arrays size
		moving_index = min(moving_index +1, movement_path.size()-1)
		going_down = false
		
		# further instruction in stopped() function
		has_exec_stopping = true
	
#	position = position.linear_interpolate(Vector2(position.x, floor_to_y(movement_path[moving_index])), 0.15)
	if current_floor < movement_path[moving_index]:
		if going_down==false:
			position.y =  max(position.y-(vertical_speed * delta), floor_to_y(movement_path[moving_index]))
#			position = position.linear_interpolate(Vector2(position.x, floor_to_y(movement_path[moving_index])), 0.15)
			going_up = true
			going_down = false
		
	elif current_floor > movement_path[moving_index]:
		position.y =  min(position.y+(vertical_speed * delta), floor_to_y(movement_path[moving_index]))
#		position = position.linear_interpolate(Vector2(position.x, floor_to_y(movement_path[moving_index])), 0.15)
#		print("ran here for a sec")
		going_down = true
		going_up = false


func stopping(delta):
	if has_exec_stopping:
		stopped = true
		has_exec_stopping = false
	
	if stopped == true:
		if current_floor != movement_path[moving_index]:
			position.y = floor_to_y(movement_path[moving_index-1])
#			position = position.linear_interpolate(Vector2(position.x, floor_to_y(movement_path[moving_index-1])), 0.15)
	
		stopped_time_counter += delta
		stopped = true
	
	if stopped_time_counter >= stopped_time:
		stopped = false
		stopped_time_counter = 0


func _process(delta):
	zig_elevator_movement_path()
	
	if !stopped:
		pass
		moving(delta)
	
	stopping(delta)
	
	
	$Current_floor.text = "current_floor: "+str(-(stepify(position.y/height, 0.01))+floors)
	current_floor = -(stepify(position.y/height, 0.01))+floors
	$going_up.text = "going_up: " + str(going_up)
	$going_down.text = "going_down: " + str(going_down)
	$stopped.text = "stopped: " + str(stopped)
	$stopped_time_counter.text = "stopped_timer_counter: " + str(stopped_time_counter)
	$Number_of_passengers.text = "passengers: "+str(passengers) + "/" + str(max_passengers)
	$Moving_index.text = "moving_index: " + str(moving_index)
	
	update()
	


func _input(event):
	elevator_debug(event)



# Using "Shift" for "debug_2"
func elevator_debug(event):
	if event.is_action_pressed("debug_2") and $Current_floor.visible:
		$Current_floor.hide()
		$going_up.hide()
		$going_down.hide()
		$stopped.hide()
		$stopped_time_counter.hide()
		$Number_of_passengers.hide()
		$Moving_index.hide()
	elif event.is_action_pressed("debug_2") and !$Current_floor.visible:
		$Current_floor.show()
		$going_up.show()
		$going_down.show()
		$stopped.show()
		$stopped_time_counter.show()
		$Number_of_passengers.show()
		$Moving_index.show()




func _draw():
	var beginning_loc = Vector2(40, -45)#height)
	var diagonal_offset = 20
	for i in available_slots.size():
		for j in available_slots[i].size():#available_slots[i]:
			var gap_x = height/3
			var gap_y = 15
			var loc_x = (i*gap_x) + beginning_loc.x + (diagonal_offset*j)
			var loc_y = (j*gap_y) + beginning_loc.y
			if available_slots[j][i] == 0:
				var _blue = Color.blue
				_blue.a = 0.4
				draw_circle(Vector2(loc_x, loc_y), 10, _blue)
			else:
				var _red = Color.red
				_red.a = 0.7
				draw_circle(Vector2(loc_x, loc_y), 10, _red)
