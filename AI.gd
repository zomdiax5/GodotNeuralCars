extends KinematicBody2D

onready var net :NN = $NN

var id

func _ready() -> void:
	randomize()
	id = int(rand_range(-9999999,9999999))
	net.create_net([4,2,2])

func map_to_value(value,maximum):
	return (value/maximum)-0.5

onready var target = get_tree().get_nodes_in_group("target")[0]

func _physics_process(delta: float) -> void:
	if global_position.x < 0:
		global_position.x = 0
	if global_position.x > 1280:
		global_position.x = 1280
	if global_position.y < 0:
		global_position.y = 0
	if global_position.y > 720:
		global_position.y = 720
	var data = [\
	map_to_value(global_position.x,1280),
	map_to_value(global_position.y,720),
	map_to_value(target.global_position.x,1280),
	map_to_value(target.global_position.y,720)
	]
	var result = net.calculate(data)
	var horizontal :float = result[0]
	var vertical :float = result[1]

	move_and_slide(Vector2(horizontal,-vertical).normalized()*delta*4000,Vector2.UP)
