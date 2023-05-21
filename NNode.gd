extends Object
class_name NNode

var weights = []

var value :float = 0

var bias :float

var sum :float = 0

var type :String

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func activation_function(sum :float):
	#return (((sum*3) / (1 + abs(sum*3)))+bias)
	return (tanh(sum) + bias)

func calculate(inputs = []):
	sum = 0
	for i in inputs.size():
		sum += inputs[i].value * weights[i]
	value = activation_function(sum)
	return value

func mutate():
	rng.seed = Global.rand
	Global.rand = rng.randi()
	var weight_diff = Global.mutation_amount
	if rng.randf_range(0,100) < 100:
		weight_diff*=100
	for i in range(0,weights.size()):
		var neg = tanh(abs(weights[i]))
		var pos = neg
		if weights[i] > 0:
			neg = 1
		else:
			pos = 1

		var change = rng.randf_range(
			(weight_diff*-1)*neg,
			weight_diff*pos) # TODO should slowly make the max/min values less propable, rather than fully disabling it suddenly
		weights[i] += change*tanh(weights[i])
		weights[i] = clamp(weights[i],-5.0,5.0)
	bias += rng.randf_range(-Global.mutation_amount*2,Global.mutation_amount*2)
	bias = clamp(bias,-1,1)

	if not Global.use_bias:
		bias = 0
