extends Node2D



var floors = 2 # how big is this building anyways
var starting_floor
var destination_floor = 2
var current_floor
var in_elevator = ""

var states = ["idle", "move_left", "move_right"] # just so you know
var wander_array = ["move_left","move_left", "move_left","move_right","move_right","move_right"]
#var wander_array = ["move_left","move_right","move_left","move_right", "move_left","move_right", "move_left"]
var wander_index = 0
var current_state = ""

var height = 227
var step_length = 227/4
var horizontal_speed = 200

var has_exec_grabPosition = false
var has_exec_set_idle = false

# holds the previous position before the movement
# to keep track of the difference in length and therefor  to stop the movement
var temp_position : Vector2

var wait_time = 0

var draw_debug_line = true # those color lines nah


# This overlay debugger node thing is the same as gonkkiess. Using some
#of his script now the label is not attached to the canvas but the node parenent
#also no fps and system stats stuff
func debugging():
#	$Overlay.add_stat("position X", self, "position", false)
#	$Overlay.add_stat("temp position X", self, "temp_position", false)
	$Overlay.add_stat("in_elevator", self, "in_elevator", false)
	$Overlay.add_stat("current_state", self, "current_state", false)
	$Overlay.add_stat("current_floor", self, "current_floor", false)
	$Overlay.add_stat("destination_floor", self, "destination_floor", false)
	$Overlay.add_stat("wait_time", self, "wait_time", false)
	

func _ready():
	debugging()
	
	#	inherit floors from parent abeg
	if "floors" in get_parent():
		floors = get_parent().floors
	
#	this is actually approximated to max! cuz persons are giving 0.2 floats
	current_floor =  -(stepify(position.y/height, 1))+floors + 1
	
	randomize()
	
	$person_sprite.modulate = Color(randf(), randf(), randf())
#	seed(23456781)
	
	destination_floor = randi() % (floors+1)
	
	# send our wait_time id to the building
	if current_floor != destination_floor:
		# The parent is an elevator holder therefor a building
		if "elevator_array" in get_parent():
			get_parent().wait_time_array[name] = self
	
#	randomize()
	yield(get_tree().create_timer(rand_range(0.1,0.9)),"timeout")
	$AnimationPlayer.playback_speed = rand_range(0.7,1.2)
	$AnimationPlayer.play("jumpy")




func update_moving(_current_state, delta):
	if _current_state == "move_right":
		if !has_exec_grabPosition:
			temp_position = position
			has_exec_grabPosition = true
		position.x = min(position.x + (horizontal_speed *delta), temp_position.x + step_length)
	if _current_state == "move_left":
		if !has_exec_grabPosition:
			temp_position = position
			has_exec_grabPosition = true
		position.x = max(position.x - (horizontal_speed *delta), temp_position.x - step_length)


func direct_to_elevator(v):
	if v.stopped:
		if v.current_floor == current_floor:
			if position.x <= v.position.x + 110:
				current_state = "move_right"
			elif position.x  >= v.position.x + (v.height+30):
				current_state = "move_left"
			else:
				current_state = "idle"
				pass
	else:
		current_state = "idle"
		pass


func update_idle_state():
	if !has_exec_set_idle:
		if position.x == temp_position.x + step_length:
			current_state = "idle"
			has_exec_set_idle = true
#			has_exec_grabPosition = false
		elif position.x == temp_position.x - step_length:
			current_state = "idle"
			has_exec_set_idle = true
#			has_exec_grabPosition = false
	
	if position.x == temp_position.x + step_length:
		has_exec_grabPosition = false
		current_state = "idle"
	elif position.x == temp_position.x - step_length:
		has_exec_grabPosition = false
		current_state = "idle"


func placing_in_elevator(v):
	var beginning_loc = Vector2(40, v.height)
	var diagonal_offset = 20
	
	for i in v.available_slots.size():
		for j in v.available_slots[i].size():#available_slots[i]:
			var gap_x = v.height/3
			var gap_y = 15
			var loc_x = (i*gap_x) + beginning_loc.x + (diagonal_offset*j)
			var loc_y = (j*gap_y) + beginning_loc.y
			if v.available_slots[j][i] == 0:
				position = Vector2(loc_x, loc_y)
#				position = position.linear_interpolate(Vector2(loc_x, loc_y),0.29)
				
				#tell elevator that the slot has been taken
				v.available_slots[j][i] = 1
				return


func undo_placing_in_elevator(v):
	var beginning_loc = Vector2(40, v.height)
	var diagonal_offset = 20
	
	for i in v.available_slots.size():
		for j in v.available_slots[i].size():#available_slots[i]:
			var gap_x = v.height/3
			var gap_y = 15
			var loc_x = (i*gap_x) + beginning_loc.x + (diagonal_offset*j)
			var loc_y = (j*gap_y) + beginning_loc.y
			if v.available_slots[j][i] == 1:
				if position == Vector2(loc_x, loc_y):
					
					#tell elevator that the slot has been given back (untaken)
					v.available_slots[j][i] = 0
					return


func enter_elevator(v):
	if current_floor != destination_floor and current_floor == v.current_floor:
		if position.x >= v.position.x + 100 and (position.x) <= (v.position.x+(v.height+30)): # actually width 
			var temp_self=self
	#		queue_free()
			get_parent().remove_child(self)
			
			placing_in_elevator(v)
			
			temp_self.current_state = "idle"
			v.add_child(temp_self)
			v.passengers += 1


func exit_elevator(v):
	var _world = v.get_parent()
	var temp_self=self
	var temp_self_parent = self.get_parent()
	
	v.remove_child(self)
	
	undo_placing_in_elevator(v)
	
	temp_self.position = position + temp_self_parent.position# + _world.to_global(position)
	
	temp_self.has_exec_grabPosition = false
	wander_index = 0

	_world.add_child(temp_self)
	v.passengers -= 1


func wander_arround():
	if wander_index < wander_array.size():
		if !has_exec_grabPosition:
#			randomize()
#			wander_array.shuffle()
			if randi() % 2 == 0:
				wander_array.invert()
			else:
				wander_array.shuffle()
			current_state = wander_array[wander_index]
			
			if wander_index == wander_array.size()-1:
				# person will make a random destination floor (0 to floors)
				# after wander is complete
#				destination_floor = randi() % (floors+1)
				pass
			wander_index += 1


func update_animation():
	if current_state == "idle":
#		$AnimationPlayer.play("RESET")
		pass
	elif current_state == "move_left" or current_state == "move_right":
##		yield(get_tree().create_timer(rand_range(0.1,0.3)),"timeout")
#		randomize()
#		$AnimationPlayer.playback_speed = rand_range(1,2)
#		$AnimationPlayer.play("jumpy")
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_moving(current_state, delta)
	update_idle_state()
	
	# outside elevator!!!
	
	# look for the closest elevator
	if "elevator_array" in get_parent():
		var nearest_v = get_parent().elevator_array[0]
		for v in get_parent().elevator_array:
			
			# look for the closest elevator
			if (v.global_position).distance_to(global_position) < (nearest_v.global_position).distance_to(global_position) and v.passengers < v.max_passengers:
				nearest_v = v
				
		
			
		if nearest_v.passengers < nearest_v.max_passengers:
			if destination_floor > nearest_v.current_floor and nearest_v.going_up:
				direct_to_elevator(nearest_v)
				enter_elevator(nearest_v)
			elif destination_floor < nearest_v.current_floor and nearest_v.going_down:
				direct_to_elevator(nearest_v)
				enter_elevator(nearest_v)
		else:
			# this thiing here wasted 40 mins of my time
			current_state = "idle"
		
		# in destination floor
		if current_floor == destination_floor:
			wander_arround()
			
	
	# inside elevator!!!
	if get_parent().is_in_group("Elevator"):
		in_elevator = get_parent().name
		current_floor = get_parent().current_floor
		if get_parent().current_floor == destination_floor:
			if get_parent().stopped:
				exit_elevator(get_parent())
				
				pass
	else:
		in_elevator = ""
		pass
	
	calculate_wait_time(delta)
	
	update()


func calculate_wait_time(delta):
	if current_floor != destination_floor:
		wait_time += delta 


func _input(event):
	if event is InputEventKey:
		debug_person_info(event)
		debug_person_info_lines(event)


func debug_person_info(event):
	if event.is_action_pressed("debug_3") and $Overlay.visible:
		$Overlay.hide()
	elif event.is_action_pressed("debug_3") and !$Overlay.visible:
		$Overlay.show()

func debug_person_info_lines(event):
	if event.is_action_pressed("debug_4"):
		draw_debug_line = not draw_debug_line

func _draw():
	if current_floor == destination_floor or not draw_debug_line:
		return
	if "elevator_array" in get_parent():
		var nearest_v = get_parent().elevator_array[0]
		for v in get_parent().elevator_array:
			
			# look for the closest elevator
			if (v.global_position).distance_to(global_position) < (nearest_v.global_position).distance_to(global_position) and v.passengers < v.max_passengers:
				nearest_v = v
				
		draw_line(Vector2.ZERO, nearest_v.position - position + (Vector2(height/2,height/2)), $person_sprite.modulate, 3.0)
		
