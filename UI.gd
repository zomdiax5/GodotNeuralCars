extends VBoxContainer

func _ready() -> void:
	Global.connect("next_run",self,"next")
	$Timescale.connect("value_changed",Global,"setval",["timescale"])                      
	$MutationAmount.connect("value_changed",Global,"setval",["mutation_amount"])                      
	$MutationChance.connect("value_changed",Global,"setval",["mutation_chance"])                      
	$NumberOfAI.connect("value_changed",Global,"setval",["amount_of_AI"])                      
	$CopyBrain.connect("toggled",Global,"setval",["always_copy_brain"])                      
	$Restart.connect("pressed",Global,"emit_signal",["restart"])

#func _process(delta: float) -> void:
	#print(Global.timescale)

func next(run,best):
	$CurrentRun.text = "Last Run: %s" % run
	$PreviusBestScore.text = "Best Score: %s" % best
