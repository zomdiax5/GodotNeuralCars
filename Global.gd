extends Node

var mutation_rate :float = 0.001

var timescale :float = 1.0

var amount_of_AI :int = 100

signal next_run(number,best)
signal restart

func setval(value,variable_name):
	set(variable_name,value)
