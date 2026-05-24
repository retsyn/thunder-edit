extends Control

@onready var wave_editor_field = $Sequence/SequenceHBox/TabContainer/CombatWave/WaveControlsVBox/Wave/EditorField
@onready var event_list = $Sequence/SequenceHBox/SequenceList
@onready var edited_sequence = Sequence.new()


func _ready():
	pass

func get_editorfield():
	return wave_editor_field


func _on_add_combat_pressed():
	var new_combat_event = CombatSequence.new()
	edited_sequence.event_list.append(new_combat_event)
	_refresh_list()
	

func _refresh_list():
	event_list.clear()
	var index_counter = 0
	for event in edited_sequence.event_list:
		index_counter += 1

		if event is CombatSequence:
			event_list.add_item("%s. COMBAT" % index_counter)

		if event is DialogEvent:
			event_list.add_item("%s. DIALOG" % index_counter)

		if event is BranchEvent:
			event_list.add_item("%s. BRANCH: %s" % [index_counter, event.target_name])

		if event is ChoiceEvent:
			event_list.add_item("%s. CHOICE: %s/%s/%s/%s" % [index_counter, event.top_choice_name, event.left_choice_name, event.right_choice_name, event.bottom_choice_name])

		if event is EndEvent:
			event_list.add_item("%s END: %s" % event.end_type)

		if event is FlagData:
			event_list.add_item("%s FLAG: %s to %s" % [event.flagname, event.setting]	)

		if event is FlightPathEvent:
			event_list.add_item("%s FLIGHTPATH: %s" % event.node)

		if event is GotoEvent:
			event_list.add_item("%s GOTO: %s w/ %s" % event.target_branch, event.flag)

		 


		
		


	
