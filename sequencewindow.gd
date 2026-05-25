extends Control

@onready var wave_editor_field = $Sequence/SequenceHBox/TabContainer/CombatWave/WaveControlsVBox/Wave/EditorField
@onready var event_list = $Sequence/SequenceHBox/SequenceList
@onready var edited_sequence = Sequence.new()

@export var selected_index: int


func _ready():
	pass

func get_editorfield():
	return wave_editor_field


func _on_add_combat_pressed():
	var new_event = CombatSequence.new()
	_add_event(new_event)


func _on_add_dialog_pressed():
	var new_event = DialogEvent.new()
	_add_event(new_event)


func _on_add_choice_pressed():
	var new_event = ChoiceEvent.new()
	_add_event(new_event)


func _on_add_flag_pressed():
	var new_event = FlagEvent.new()
	_add_event(new_event)


func _on_add_cinematic_pressed():
	var new_event = CinemaEvent.new()
	_add_event(new_event)


func _on_add_flight_path_pressed():
	var new_event = FlightPathEvent.new()
	_add_event(new_event)


func _on_add_branch_pressed():
	var new_event = BranchEvent.new()
	_add_event(new_event)


func _on_add_goto_pressed():
	var new_event = GotoEvent.new()
	_add_event(new_event)


func _on_add_exit_pressed():
	var new_event = EndEvent.new()
	_add_event(new_event)



func _add_event(new_event):
	if(len(edited_sequence.event_list) > 0):
		edited_sequence.event_list.insert(selected_index + 1, new_event)
	else:
		edited_sequence.event_list.append(new_event)
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
			event_list.add_item("%s END: %s" % [index_counter, event.end_type])

		if event is FlagEvent:
			event_list.add_item("%s FLAG: %s to %s" % [index_counter, event.flagname, event.setting]	)

		if event is FlightPathEvent:
			event_list.add_item("%s FLIGHTPATH: %s" % [index_counter, event.node])

		if event is CinemaEvent:
			event_list.add_item("%s CINEMA: %s" % [index_counter, event.path])

		if event is GotoEvent:
			event_list.add_item("%s GOTO: %s w/ %s" % [index_counter, event.target_branch, event.flag])


func _on_sequence_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int):
	selected_index = index
	_show_related_tab()


func _on_sequence_list_item_activated(index: int):
	selected_index = index
	_show_related_tab()


func _show_related_tab():
	var show_tab = 0
	if edited_sequence.event_list[selected_index] is DialogEvent:
		show_tab = 0
	if edited_sequence.event_list[selected_index] is CombatSequence:
		show_tab = 1
	if edited_sequence.event_list[selected_index] is ChoiceEvent:
		show_tab = 2
	if edited_sequence.event_list[selected_index] is FlagEvent:
		show_tab = 3
	if edited_sequence.event_list[selected_index] is CinemaEvent:
		show_tab = 4
	if edited_sequence.event_list[selected_index] is FlightPathEvent:
		show_tab = 5
	if edited_sequence.event_list[selected_index] is BranchEvent:
		show_tab = 6
	if edited_sequence.event_list[selected_index] is GotoEvent:
		show_tab = 7
	if edited_sequence.event_list[selected_index] is EndEvent:
		show_tab = 8

	$Sequence/SequenceHBox/TabContainer.current_tab = show_tab
	