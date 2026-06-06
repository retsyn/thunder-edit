extends Control

# @onready var wave_editor_field = $Sequence/SequenceHBox/TabContainer/CombatWave/WaveControlsVBox/Wave/EditorField
@onready var event_list = $Sequence/SequenceHBox/SequenceList


func _on_ready():
	print("Creating new editor state...")
	EditorState.new_sequence()

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
	if(EditorState.selected_index == -1):
		EditorState.edited_sequence.event_list.append(new_event)
		EditorState.selected_index = 0
	else:
		EditorState.edited_sequence.event_list.insert(EditorState.selected_index + 1, new_event)
		EditorState.selected_index += 1

	_refresh_list()	
	print("List size is %s and selection is %s" % [len(EditorState.edited_sequence.event_list), EditorState.selected_index])
	event_list.select(EditorState.selected_index)
	_show_related_tab()
	


func _refresh_list():
	event_list.clear()
	var index_counter = 0
	for event in EditorState.edited_sequence.event_list:
		index_counter += 1

		if event is CombatSequence:
			event_list.add_item("%s-" % index_counter, load("res://icon2.png"))

		if event is DialogEvent:
			event_list.add_item("%s-" % index_counter, load("res://icon1.png"))

		if event is ChoiceEvent:
			event_list.add_item("%s-%s/%s/%s/%s" % [index_counter, event.top_choice_name, event.left_choice_name, event.right_choice_name, event.bottom_choice_name], load("res://icon3.png"))

		if event is FlagEvent:
			event_list.add_item("%s-%s to %s" % [index_counter, event.flagname, event.setting], load("res://icon4.png"))

		if event is CinemaEvent:
			event_list.add_item("%s-%s" % [index_counter, event.path], load("res://icon5.png"))

		if event is FlightPathEvent:
			event_list.add_item("%s-%s" % [index_counter, event.node], load("res://icon6.png"))

		if event is BranchEvent:
			event_list.add_item("%s-: %s" % [index_counter, event.target_name], load("res://icon7.png"))

		if event is GotoEvent:
			event_list.add_item("%s-%s w/ %s" % [index_counter, event.target_branch, event.flag], load("res://icon8.png"))

		if event is EndEvent:
			event_list.add_item("%s-%s" % [index_counter, event.end_type], load("res://icon9.png"))



func _on_sequence_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int):
	EditorState.selected_index = index
	_show_related_tab()


func _on_sequence_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int):
	EditorState.selected_index = -1



func _on_sequence_list_item_activated(index: int):
	EditorState.selected_index = index
	_show_related_tab()


func _show_related_tab():
	var show_tab = 0
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is DialogEvent:
		show_tab = 0
		# Enforce that this tab is refreshed-- just in case two dialog tabs are edited in a row.
		$Sequence/SequenceHBox/TabContainer/Dialog._refresh_dialog_list()
		$Sequence/SequenceHBox/TabContainer/Dialog.selected_dialog = -1

	if EditorState.edited_sequence.event_list[EditorState.selected_index] is CombatSequence:
		show_tab = 1
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is ChoiceEvent:
		show_tab = 2
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is FlagEvent:
		show_tab = 3
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is CinemaEvent:
		show_tab = 4
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is FlightPathEvent:
		show_tab = 5
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is BranchEvent:
		show_tab = 6
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is GotoEvent:
		show_tab = 7
	if EditorState.edited_sequence.event_list[EditorState.selected_index] is EndEvent:
		show_tab = 8

	$Sequence/SequenceHBox/TabContainer.current_tab = show_tab
	


