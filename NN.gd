extends Object
class_name NN

var neural_net = []


func create_net(size_of_layers = []):	# Create a neural network
	for layer in range(0,size_of_layers.size()):
		var previous_layer = []
		if layer != 0:
			previous_layer = neural_net[layer-1]
		var is_last :bool = false
		if layer == size_of_layers.size()-1:
			is_last = true
		neural_net.append(_create_layer(previous_layer,"",size_of_layers[layer],is_last))

	# Create a layer of neurons
func _create_layer(previous_layer = [], type:String = "", size:int = 0,is_last:bool = false):
	var arr = []
	if previous_layer == []:
		type = "input"
	if is_last:
		type = "output"
	for i in range(0,size):
		arr.append(_create_node(previous_layer,type))
	return arr

	# Create Neuron
func _create_node(previous_layer, type):
	var new_node :NNode = NNode.new()
	new_node.type = type
	
	if type != "input":
		for node in range(0,previous_layer.size()):
			new_node.weights.append(rand_range(-1,1))
	
	new_node.bias = rand_range(-Global.default_bias,Global.default_bias)
	if not Global.use_bias:
		new_node.bias = 0
	return new_node

var results
var size :int = 0

# Calculate Net Output
func calculate(inputs := []):
	results = []
	size = neural_net.size()
	for l in range(0,size):
		if (l !=0 and l != size-1):
			for node in neural_net[l]: # Normal calculations
				node.calculate(neural_net[l-1])
			continue
		elif l == 0: 
			for i in range(0,neural_net[l].size()): # Setting up inputs
				neural_net[l][i].value = inputs[i]
			continue
		else: # Outputs
			for node in neural_net[l]:
				results.append(node.calculate(neural_net[l-1]))
	return results

# Mutate neurons
func mutate():
	for l in range(0,neural_net.size()):
		for node in range(0,neural_net[l].size()):
			if (neural_net[l][node].weights.size() > 0):
				neural_net[l][node].mutate()
