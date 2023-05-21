extends Object
class_name NNode

var weights = []

var value = 0

var type :String

var bias :float
var bias_weight :float

var sum :float = 0


func activation_function(sum :float):
	return ((sum*3) / (1 + abs(sum*3)))+(bias*bias_weight)
	#return tanh(sum)

func calculate(inputs = []):
	sum = 0
	for i in inputs.size():
		sum += inputs[i].value * weights[i]
	value = activation_function(sum)
	return value

func mutate():
	var weight_diff = Global.mutation_amount
	for i in range(0,weights.size()):
		var change = rand_range(
			(weight_diff*-1),
			weight_diff) # TODO should slowly make the max/min values less propable, rather than fully disabling it suddenly
		weights[i] += change
		weights[i] = clamp(weights[i],-5.0,5.0)
	bias_weight += rand_range(-Global.mutation_amount,-Global.mutation_amount)
	bias_weight = clamp(bias_weight,-5,5)
	
	
	if not Global.use_bias:
		bias = 0
