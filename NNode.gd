extends Node
class_name NNode

var weights = []
var bias :float = 0

var input_nodes = []
var next_nodes = []


func activation_function(sum :float):
	return tanh(sum)

func calculate(inputs = []):
	inputs.append(bias)
	var sum :float = 0
	for i in inputs.size():
		sum+= inputs[i] * weights[i]
	return activation_function(sum)

func mutate():
	var weight_diff = 0.1
	for i in range(0,weights.size):
		weights[i] += rand_range(weights[i]-(weights[i]*weight_diff),weights[i]+(weights[i]*weight_diff))
