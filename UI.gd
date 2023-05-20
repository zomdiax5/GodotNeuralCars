extends VBoxContainer

func _ready() -> void:
	Global.connect("next_run",self,"next")
	$Timescale.connect("value_changed",Global,"setval",["timescale"])                      
	$MutationRate.connect("value_changed",Global,"setval",["mutation_rate"])                      
	$NumberOfAI.connect("value_changed",Global,"setval",["amount_of_AI"])                      
	$Restart.connect("pressed",Global,"emit_signal",["restart"])
#func _process(delta: float) -> void:
	#print(Global.timescale)

func next(run,best):
	$CurrentRun.text = "Last Run: %s" % run
	$PreviusBestScore.text = "Best Score: %s" % best
