extends Node

var run :int = 0

var timer :float = 0

var AI = preload("res://AI.tscn")

var ran :bool = false


func _ready() -> void:
	if !ran:
		Global.connect("restart",self,"restart")
		ran = true
	

func setup():
	for i in range(0,Global.amount_of_AI):
		var scene = AI.instance()
		add_child(scene)
		scene.global_position = Vector2(rand_range(0,1280),rand_range(0,720))

func _physics_process(delta:float):
	Engine.time_scale = Global.timescale
	if timer > 7:
		next_run()
		timer = 0
	timer+=delta

func restart():
	for child in get_children():
		child.queue_free()
	run = 0
	timer = 0
	setup()

func next_run():
	run += 1
	var best_score = -999999999999
	var best_node = null
	
	for node in get_children():
		var score = calculate_score(node)
		if score > best_score or best_node == null:
			best_score = score
			best_node = node
		node.global_position = Vector2(rand_range(0,1280),rand_range(0,720))
	
	for node in get_children():
		if Global.always_copy_brain and node != best_node:
			node.net.neural_net = null 
			node.net.neural_net = best_node.net.neural_net.duplicate()
		if rand_range(0,100) < Global.mutation_chance and node != best_node:
			node.net.neural_net = null 
			node.net.neural_net = best_node.net.neural_net.duplicate()
			node.net.mutate()
			
	
	print("Starting round %s..." % run)
	print("Previous best score: %s" % best_score)
	Global.emit_signal("next_run",run,best_score)
	
	reset_world()
	

func reset_world():
	var last_position = target.global_position
	while(true):
		target.global_position = Vector2(
			rand_range(1280/4,1280-(1280/4)),
			rand_range(720/4,720-(720/4))
		)
		if target.global_position.distance_to(last_position) > 400:
			break

onready var target = get_tree().get_nodes_in_group("target")[0]

func calculate_score(node :Node2D):
	var score = node.score
	node.score = 0
	return score
	
	#return 10 - node.global_position.distance_to(Vector2(1280/2,720/2))
