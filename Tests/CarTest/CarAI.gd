extends KinematicBody2D

onready var net :NN = $NN

var score :float = 0

var lost :bool = false

var checks = -1

var ignore = []

func _ready() -> void:
	randomize()
	net.create_net([5,3,2])

func map_to_value(value,maximum):
	return (value/(maximum/2))-1


func _process(delta: float) -> void:
	if lost:
		score = -1

func _physics_process(delta: float) -> void:
	move(delta)

func cast_distance(cast:RayCast2D):
	if not cast.is_colliding():
		return 0.0
	return cast.global_position.distance_to(cast.get_collision_point()) / cast.cast_to.y

onready var cast_1: RayCast2D = $cast1
onready var cast_2: RayCast2D = $cast2
onready var cast_3: RayCast2D = $cast3
onready var cast_4: RayCast2D = $cast4
onready var cast_5: RayCast2D = $cast5

var speed :float = 0.0

func reset():
	speed = 0.0
	lost = false
	checks = -1
	ignore = [] 

func move(delta :float):
	var data = [\
	cast_distance(cast_1),
	cast_distance(cast_2),
	cast_distance(cast_3),
	cast_distance(cast_4),
	cast_distance(cast_5)
	]
	var result = net.calculate(data)
	speed += result[0]
	speed = clamp(speed,-25,42)
	if lost:
		return
	move_and_slide(Vector2(speed,0).rotated(rotation)*10)
	rotation_degrees += result[1]*4.5


func _on_Area2D_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if not (body is Check):
		lost = true
		


func _on_Area2D_area_entered(area: Area2D) -> void:
	if not area is Check:
		return
	if not ignore.has(area):
		checks += 1
		ignore.append(area)
