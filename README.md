# Elevator-Simulator
my simulation of a building elevator system

<img src="https://github.com/Rocket-007/Elevator-Simulator/blob/main/github_page_files/elevator_ScreenShot.png" alt="" width="50%"/>

<img src="https://github.com/Rocket-007/Elevator-Simulator/blob/main/github_page_files/elevator_ScreenShot2.png" alt="" width="50%"/>


<br>
<br>
This project is to develop a model to simulate the behaviour of elevators in a multi-story building. By adjusting different  

variables and running simulations, we could test different theories and scenarios and investigate the impact on passenger wait times.

<br>

<img src="https://github.com/Rocket-007/Elevator-Simulator/blob/main/github_page_files/elevator_class_UML.png" alt="" width="30%"/>
<p><br></p>
<p><br></p><p>In this UML class diagram, we have five classes: <b>Simulation</b>, <b>Building</b>, <b>Floor</b>, <b>Passenger</b>, and <b>Elevator</b>.
</p>
<p><b>Simulation Class: </b>The Simulation class handles the running of the building samples for analysis. It provides control keys such as:
</p>
<p><b>Controls</b>:</p>

Arrows_keys = Pan Camera  

Z and X = Zoom Camera  

R = restart/reload running Simulation  

O = reload all  

Spacebar = pause/play Simulation  

1 and 2 = slowdown/speedup Simulation time  

Tab = Hide/Show Building Simulation data monitor  

Shift = Hide/Show Elevator data monitor  

Ctrl = Hide/show Person data monitor  

Alt = Hide/Show Person to Elevator line


<p>The Simulation class contains methods like:
</p>
<p>Methods:
</p>
<ul><li><b>zoom_in_out</b>(): method for zooming in and out on the building
</li><li><b>update_cam_movement</b>(): method for panning the camera around the building
</li><li>slow_fast_time(): slow down or speed up the simulation time scale.
</li><li>pause_and_play(): stop or continue the running simulation.
</li><li><b>reload_running_sim()</b>: reload the running simulation.
</li></ul>
<p><b>Building Class: </b>The Building class represents the overall building. It contains:&nbsp;
</p>
<ul><li>floor: attribute for the number of floors in the building
</li><li>elevator_array: A building may have more than one elevator, this contains an arrray of all the Elevator objects in the building.
</li><li>elevator_array_size: attribute for the number of elevators in the building.
</li><li>people: attribute for number of people in the building.
</li><li>wait_time_average: this is the attribute that specifies the effectiveness and efficiency of the building’s elevators system. It is simply calculated by getting the average time it takes for each person to get their destination.&nbsp;
</li><li>simulation_done: attribute that represents if the simulation for the particular building is done i.e: all persons have arrived at their destination floor.
</li><li>simulation_time: attribute that represents the time it takes the simulation for the particular building to be done
</li></ul>
<p><b>Floor Class: </b>represents each floor in the building. It contains Rooms that control the visual appearance of the floor walls.
</p>
<p><b>Person Class: </b>The Person class represents an individual in the building. It contains attributes and methods such as:
</p>
<p>Attributes:
</p>
<ul><li>destination_floor: attribute or value for the floor the person intends to go to.
</li><li>current_floor: the floor the person is currently on.
</li><li>states: array or list of the three different states the person can be on. “idle”: is not moving around, “move_left”: walks left by the distance of step_length and speed of horizontal_speed, “move_right”: walks right by the distance of step_length and speed of horizontal_speed.
</li><li>current_state: attribute specifying the state the person is in from states.
</li><li>in_elevator: contains the elevator object the person is inside if any.
</li><li>in_elevator: provides the name of the elevator the person is currently inside, blank if not in any.
</li><li>step_length: value for the distance per step the person can take.
</li><li>horizontal_speed: value for how fast a step_length is attained.
</li><li>wait_time: the time it takes for the person to get to his/her destination floor
</li></ul>
<p>Methods:
</p>
<ul><li>update_moving(current_state): method that update the person's position base on the calculated current_state.
</li><li>direct_to_elevator(Elevator): directs the person to the nearest and free(not full) elevator on the same floor.
</li><li>enter_elevator(Elevator): puts the person in the specified elevator.
</li><li>placing_in_elevator(Elevator): orderly arrange the person in the specified elevator.
</li><li><b>undo_placing_in_elevator</b>(<b>Elevator</b>): remove the placing of the person form the specified elevator.
</li><li><b>exit_elevator</b>(<b>Elevator</b>): removes the person from the specified elevator.
</li><li>calculate_wait_time(): calculates and updates the wait_time method.
</li></ul>
<p><b>Elevator Class: </b>The Elevator class represents the elevator itself. It has attributes and methods such as:
</p>
<p>Attributes:
</p>
<ul><li>current_floor: the floor the elevator is currently on.
</li><li>vertical_speed: how fast the elevator moves from floor to floor.
</li><li>passengers: amount of people in the elevator.
</li><li>max_passengers: highest number of people allowed in the elevator.
</li><li>stopped: for stopping the elevator from advancing up or down, i.e: opening the door.
</li><li>stopped_time: time for stopped to be true.
</li><li>going_up: attribute for indicating if the elevator is going to a higher floor.
</li><li>going_down: attribute tha indicates if the elevator is going to a lower floor.
</li><li>moving_index: position of the elevator in the drawn movement_path.
</li><li>movement_path: array or list containing the path the elevator will follow. In the case of this driving algorithm, the elevator uses the ‘<i>elevator algorithm’</i>.It goes in a continuous path, going to the topmost floor while stopping, picking and dropping passengers, then goes back to the down to bottomost floor while again stopping, picking and dropping passengers. This cycle repeats.
</li></ul>
<p>Methods:
</p>
<ul><li>moving(): method for processing the movement_path attribute then moving the elevator through it at a speed of vertical_speed.
</li><li>stopping(): stops the elevator for stopped_time after every new path.
</li></ul>
<p><br></p><p><br></p>
