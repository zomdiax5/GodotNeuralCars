extends Node
class_name NN

var neural_net = []


func create_net(size_of_layers = []):
	for layer in range(0,size_of_layers.size()):
		print(layer)
		var previous_layer = []
		if layer != 0:
			previous_layer = neural_net[layer-1]
		neural_net.append(_create_layer(previous_layer,"",size_of_layers[layer]))

func _create_layer(previous_layer = [], type:String = "", size:int = 0):
	var arr = []
	if previous_layer == []:
		type = "input"
	for i in range(0,size):
		arr.append(_create_node(previous_layer,type))
	return arr
	
func _create_node(previous_layer = [], type:String = ""):
	var new_node :NNode = NNode.new()
	
	if type != "input":
		for node in previous_layer:
			new_node.input_nodes.append(node)
			new_node.weights.append(rand_range(-1,1))
			print(rand_range(-1,1))
	
	new_node.bias = rand_range(-1,1)
	new_node.weights.append(rand_range(-1,1))
	return new_node

func calculate():
	for layer in size_of_layers.size():
