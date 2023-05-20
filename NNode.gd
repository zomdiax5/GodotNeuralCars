extends Node
class_name NNode

var weights = []

var value = 0

var type :String

var bias :float = rand_range(-0.03,0.03)

var sum :float = 0

func activation_function(sum :float):
	return (sum*3) / (1 + abs(sum*3))
	#return tanh(sum)

func calculate(inputs = []): # TODO add bias
	sum = 0
	for i in range(0,inputs.size()):
		sum += inputs[i].value * weights[i]
	value = activation_function(sum)
	return value

func mutate():
	var weight_diff = Global.mutation_rate
	for i in range(0,weights.size()):
		var max_p :float = 0.9
		var max_n :float = 0.9
		if weights[i] > 0.7:
			max_p = 0.1
		if weights[i] < -0.7:
			max_n = 0.1
		var change = rand_range((weight_diff*max_n *-1), weight_diff*max_p) # TODO should slowly make the max/min values less propable, rather than fully disabling it suddenly
		weights[i] += change
		weights[i] = clamp(weights[i],-1.0,1.0)
