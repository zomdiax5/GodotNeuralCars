extends KinematicBody2D

var net :NN = NN.new()

var score :float = 0

var lost :bool = false

var checks = -1 # How many Checkpoints we have passed

var ignore = [] # Ignore already passed checkpoints

onready var cast_1: RayCast2D = $cast1
onready var cast_2: RayCast2D = $cast2
onready var cast_3: RayCast2D = $cast3
onready var cast_4: RayCast2D = $cast4
onready var cast_5: RayCast2D = $cast5

onready var casts = [
	cast_1,
	cast_2,
	cast_3,
	cast_4,
	cast_5,
]

var speed :float = 0.0

func _ready() -> void:
	randomize()
	# Create a Neural Network (NN) with 5 inputs, 1 hidden layer with 4 nodes, and 2 outputs
	net.create_net([5,4,2])

func map_to_value(value,maximum): # Not used, maps value to -1 - 1 for use as input
	return (value/(maximum/2))-1


func _process(delta: float) -> void:
	if lost:
		score = -1
		modulate = Color(0.5,0.5,0.5,0.5)
	else:
		modulate = Color(1,1,1,0.7)
	update()
	
func _draw():
	if not Global.draw_stuff:
		return
	for cast in casts:
		var dist = cast_distance(cast)
		draw_line(Vector2(0,0),
		Vector2(cast.cast_to.y-(dist*cast.cast_to.y),0).rotated(cast.rotation+deg2rad(90)),
		Color(clamp(dist*2,0.3,1),0.1,0.1))

func _physics_process(delta: float) -> void:
	move(delta)

func cast_distance(cast:RayCast2D):
	if not cast.is_colliding():
		return 0.0
	return 1 - (cast.global_position.distance_to(cast.get_collision_point()) / cast.cast_to.y)

func reset(): # Reset Car
	speed = 0.0
	lost = false
	checks = -1
	ignore = [] 

func move(delta :float):	# setup Data
	var data = [\
	cast_distance(cast_1),
	cast_distance(cast_2),
	cast_distance(cast_3),
	cast_distance(cast_4),
	cast_distance(cast_5)
	]
	var result = net.calculate(data) # asks for output from the NN using Data as input
	
	# Movement
	
	speed += result[0]
	speed = clamp(speed,-25,45)
	if lost:
		return
	move_and_slide(Vector2(speed,0).rotated(rotation)*10)
	rotation_degrees += result[1]*4*(1+(Global.timescale/2))


func _on_Area2D_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if not (body is Check):		# Crash if touche a wall
		lost = true
		


func _on_Area2D_area_entered(area: Area2D) -> void:
	if not area is Check:
		return
	# If passed check and its not on the ignore list, increase counter
	if not ignore.has(area):
		checks += 1
		ignore.append(area)
