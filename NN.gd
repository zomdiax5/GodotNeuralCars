extends Node
class_name NN

var neural_net = []


func create_net(size_of_layers = []):
	for layer in range(0,size_of_layers.size()):
		var previous_layer = []
		if layer != 0:
			previous_layer = neural_net[layer-1]
		var is_last :bool = false
		if layer == size_of_layers.size()-1:
			is_last = true
		neural_net.append(_create_layer(previous_layer,"",size_of_layers[layer],is_last))

func _create_layer(previous_layer = [], type:String = "", size:int = 0,is_last:bool = false):
	var arr = []
	if previous_layer == []:
		type = "input"
	if is_last:
		type = "output"
	for i in range(0,size):
		arr.append(_create_node(previous_layer,type))
	return arr
	
func _create_node(previous_layer, type):
	var new_node :NNode = NNode.new()
	new_node.type = type
	
	if type != "input":
		for node in range(0,previous_layer.size()):
			new_node.weights.append(rand_range(-1,1))
	
	new_node.bias = rand_range(-1,1)
	new_node.weights.append(rand_range(-1,1))
	return new_node

func calculate(inputs := []):
	var results = []
	for l in range(0,neural_net.size()):
		if l == 0: 
			for i in range(0,neural_net[l].size()): # Setting up inputs
				neural_net[l][i].value = inputs[i]
			continue
		elif l == neural_net.size()-1: # Outputs
			for node in neural_net[l]:
				results.append(node.calculate(neural_net[l-1]))
		else:
			for node in neural_net[l]: # Normal calculations
				node.calculate(neural_net[l-1])
	return results

func mutate():
	for l in range(0,neural_net.size()):
		for node in neural_net[l]:
			node.mutate()
