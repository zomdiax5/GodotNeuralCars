extends Node

var mutation_amount :float = 0.001
var mutation_chance :float = 50

var timescale :float = 1.0

var amount_of_AI :int = 100

var always_copy_brain :bool = false

var use_bias :bool = false

var default_bias = 0.5

signal next_run(number,best)
signal restart


func setval(value,variable_name):
	set(variable_name,value)
