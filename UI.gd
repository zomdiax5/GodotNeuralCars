extends VBoxContainer

func _ready() -> void:
	Global.connect("next_run",self,"next")
	$Timescale.connect("value_changed",Global,"setval",["timescale"])
	Global.setval($Timescale.value,"timescale")                     
	
	$MutationAmount.connect("value_changed",Global,"setval",["mutation_amount"])                      
	Global.setval($MutationAmount.value,"mutation_amount")  
	
	$MutationChance.connect("value_changed",Global,"setval",["mutation_chance"])                      
	Global.setval($MutationChance.value,"mutation_chance")  
	
	$NumberOfAI.connect("value_changed",Global,"setval",["amount_of_AI"])                      
	Global.setval($NumberOfAI.value,"amount_of_AI")  
	
	$CopyBrain.connect("toggled",Global,"setval",["always_copy_brain"])                      
	Global.setval($CopyBrain.pressed,"always_copy_brain")  
	
	$Restart.connect("pressed",Global,"emit_signal",["restart"])
	Global.emit_signal("restart")
	

func next(run,best):
	$CurrentRun.text = "Last Run: %s" % run
	$PreviusBestScore.text = "Best Score: %s" % best
