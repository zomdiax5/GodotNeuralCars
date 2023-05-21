extends Object
class_name NNode

var weights = []

var value :float = 0

var bias :float

var sum :float = 0

var type :String

# Maps the calculated value to a value in the range of
# -1 to 1 using tanh() and adds the bias value to them
func activation_function(sum :float):
	return (tanh(sum) + bias)

# Calculate this neuron's value by multiplying all the inputs
# by their weights
func calculate(inputs = []):
	sum = 0
	for i in inputs.size():
		sum += inputs[i].value * weights[i]
	value = activation_function(sum)
	return value

# Mutates the weights and bias by the specified amount
# With a chance to them it a lot
func mutate():
	var weight_diff = Global.mutation_amount
	if rand_range(0,100) < Global.mutation_chance/20:
		weight_diff*=10
	for i in range(0,weights.size()):
		var neg = tanh(abs(weights[i])) # Makes the weights less likely to be the minimum/maximum value
		var pos = neg
		if weights[i] > 0:
			neg = 1
		else:
			pos = 1

		var change = rand_range(
			(weight_diff*-1)*neg,
			weight_diff*pos)
		weights[i] += change*tanh(weights[i])
		weights[i] = clamp(weights[i],-5.0,5.0)
	bias += rand_range(-Global.mutation_amount*2,Global.mutation_amount*2)
	bias = clamp(bias,-1,1)

	if not Global.use_bias:
		bias = 0
