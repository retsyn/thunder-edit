extends HBoxContainer
@onready var EntityPalette = $MarginContainer/EntityPaletteVBox/EntitySelectList
@onready var CurrentPage = 0
@onready var editor_field = $WaveControlsVBox/Wave/EditorField
@onready var pagelabel = $WaveControlsVBox/Wave/PageLabel


func _on_page_left_button_pressed():
	if(_editor_state_valid()):
		page_down()


func _on_page_right_button_pressed():
	if(_editor_state_valid()):
		page_up()


func _editor_state_valid():
	# Don't use these buttons if we have no sequences.
	if(EditorState.selected_index == -1):
		return false

	# Don't use these buttons if we aren't on a CombatSequence.
	var event = EditorState.edited_sequence.event_list[EditorState.selected_index]
	if(event is not CombatSequence):
		return false

	return true


func page_up():
	CurrentPage += 1
	if (CurrentPage >= EditorState.edited_sequence.event_list[EditorState.selected_index].page_list.size()):
		print("Adding a fresh page.")
		EditorState.edited_sequence.event_list[EditorState.selected_index].page_list.append(CombatPage.new())
	refresh_page()


func page_down():
	if (CurrentPage > 0):
		CurrentPage -= 1
		refresh_page()


func _on_page_two_button_pressed() -> void:
	pass # Replace with function body.


func refresh_page():
	var event = EditorState.edited_sequence.event_list[EditorState.selected_index]
	pagelabel.text = "P:%d/%d" % [CurrentPage, event.page_list.size() - 1]
	

	if CurrentPage < event.page_list.size():
		var page = event.page_list[CurrentPage]
		editor_field.load_entries(page)
		print("Loading entries on page %s" % page)
		$WaveControlsVBox/PageTypeHBox/PageTypeOption.select(page.flip_type)
		$WaveControlsVBox/ApproachControlHBox/ApproachOption.select(page.approach_type)
		$WaveControlsVBox/PageTypeHBox/TimerSpinBox.value = page.timer
	else:
		$WaveControlsVBox/PageTypeHBox/PageTypeOption.select(0)
		$WaveControlsVBox/ApproachControlHBox/ApproachOption.select(0)
		$WaveControlsVBox/PageTypeHBox/TimerSpinBox.value = 0
