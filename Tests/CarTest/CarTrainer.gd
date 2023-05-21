extends Node

var run :int = 0

var timer :float = 0

var AI = preload("res://Tests/CarTest/CarAI.tscn")

var ran :bool = false


func _ready() -> void:
	if !ran:
		Global.connect("restart",self,"restart")
		ran = true


func setup():
	for i in range(0,Global.amount_of_AI):
		var scene = AI.instance()
		add_child(scene)
		scene.global_position = Vector2(0,0)
		scene.rotation_degrees = 90

func _physics_process(delta:float):
	Engine.time_scale = Global.timescale
	if timer > 30:
		next_run()
		timer = 0
	timer+=delta
	var x = false
	for car in get_children():
		if not car.lost:
			x = true
	if x != true:
		timer = 999

func restart():
	for child in get_children():
		child.queue_free()
	yield(get_tree(),"idle_frame")
	run = 0
	timer = 0
	setup()

func next_run():
	run += 1
	
	var nodes = []
	
	var best_score :float = -99999999
	
	var children = get_children()
	
	for node in range(0,children.size()):
		nodes.append({"node":children[node]})
		var score = calculate_score(children[node])
		nodes[node]["score"] = score
		children[node].global_position = Vector2(0,0)
		children[node].rotation_degrees = 90
		if score > best_score:
			best_score = score
	
	nodes.sort_custom(self,"bigger_score")
	
	for node in get_children():
		var other_node = null
		while true:
			other_node = nodes[int(rand_range(0,min(nodes.size(),nodes.size()/15)))]
			if (other_node["node"] != node):
				break
		for l in range(0,node.net.neural_net.size()):
			for n in range(0,node.net.neural_net[l].size()):
				node.net.neural_net[l][n].weights = other_node["node"].net.neural_net[l][n].weights.duplicate(true)
				node.net.neural_net[l][n].bias = other_node["node"].net.neural_net[l][n].bias
		
		if rand_range(0,100) < Global.mutation_chance: 
			node.net.mutate()


	print("Starting round %s..." % run)
	print("Previous best score: %s" % best_score)
	Global.emit_signal("next_run",run,best_score)

	reset_world()


func bigger_score(a,b):
	return a["score"] > b["score"]

func reset_world():
	pass

func calculate_score(node :Node2D):
	var score
	score = node.checks * 400 + node.global_position.distance_to(
		get_tree().get_nodes_in_group("Check")[node.checks].global_position
	)
	node.reset()
	return score

	#return 10 - node.global_position.distance_to(Vector2(1280/2,720/2))
