extends Node

var run :int = 0

var timer :float = 0

var AI = preload("res://Tests/CarTest/CarAI.tscn")



func _ready() -> void:
	Global.connect("restart",self,"restart")


func setup():	# Setup AIs
	for i in range(0,Global.amount_of_AI):
		var scene = AI.instance()
		add_child(scene)
		scene.global_position = Vector2(0,0)
		scene.rotation_degrees = 90

func _physics_process(delta:float):
	Engine.time_scale = Global.timescale
	if timer > 30:	# End current run after X seconds
		next_run()
		timer = 0
	timer+=delta
	
	# If everyone crashed, end run quicker
	var x = false
	for car in get_children():
		if not car.lost:
			x = true
	if x != true:
		timer = 999

func restart():	# Restart the whole simulation
	for child in get_children():
		child.queue_free()
	yield(get_tree(),"idle_frame")
	run = 0
	timer = 0
	setup()

func next_run():	# Stuff that happens when the run ends
	run += 1
	
	var nodes = []
	
	var best_score :float = -99999999
	
	var children = get_children()
	
	# Get best score and make a list with all AIs and their scores
	for node in range(0,children.size()):
		nodes.append({"node":children[node]})
		var score = calculate_score(children[node])
		nodes[node]["score"] = score
		children[node].global_position = Vector2(0,0)
		children[node].rotation_degrees = 90
		if score > best_score:
			best_score = score
	
	# Sort the arr of AIs according to their Score
	nodes.sort_custom(self,"bigger_score")
	
	for node in get_children():
		# Get a radnom one of the best AIs
		var other_node = null
		while true:
			other_node = nodes[int(rand_range(0,min(nodes.size(),nodes.size()/15)))]
			if (other_node["node"] != node):
				break
		# Copy its AI into others
		for l in range(0,node.net.neural_net.size()):
			for n in range(0,node.net.neural_net[l].size()):
				node.net.neural_net[l][n].weights = other_node["node"].net.neural_net[l][n].weights.duplicate(true)
				node.net.neural_net[l][n].bias = other_node["node"].net.neural_net[l][n].bias
		# Mutate some random AI according to the setting
		if rand_range(0,100) < Global.mutation_chance: 
			node.net.mutate()


	print("Starting round %s..." % run)
	print("Previous best score: %s" % best_score)
	Global.emit_signal("next_run",run,best_score)

	reset_world()


func bigger_score(a,b):		# Function used to sort Dict of AIs
	return a["score"] > b["score"]

func reset_world():
	pass

func calculate_score(node :Node2D):		# Get the AI's score
	var score
	score = node.checks * 400 + node.global_position.distance_to(
		get_tree().get_nodes_in_group("Check")[node.checks].global_position
	)
	node.reset()
	return score
