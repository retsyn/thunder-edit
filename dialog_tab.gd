extends Control

@onready var dialog_list = $DialogVBox/DialogEntries
@onready var selected_dialog = -1
@onready var portrait_dropdown = $DialogVBox/DialogHBox/PortraitOption
@onready var code_field = $DialogVBox/DialogHBox/TextCodeEdit

func _on_insert_dialog_button_pressed():
	print("Insert Dialog Pressed")
	if(EditorState.selected_index == -1):
		print("No event created.")
		return
	if(EditorState.edited_sequence.event_list[EditorState.selected_index] is not DialogEvent):
		print("Event selected isn't a DialogEvent")
		return
	
	_add_dialog()


func _add_dialog():
	
	var event = EditorState.edited_sequence.event_list[EditorState.selected_index]
	if(event is DialogEvent):
		if(selected_dialog == -1):
			event.append_entry(portrait_dropdown.selected, code_field.text)
			selected_dialog = 0
			
		else:
			event.insert_entry(portrait_dropdown.selected, code_field.text, selected_dialog + 1)
			selected_dialog += 1
	
	_refresh_dialog_list()	


func _refresh_dialog_list():
	dialog_list.clear()
	var index_counter = 0
	for event in EditorState.edited_sequence.event_list[EditorState.selected_index].entry_list:

		index_counter += 1
		dialog_list.add_item("%s. %s %s" % [index_counter, event['portrait'], event['text']])


func _on_dialog_entries_item_selected(index):
	selected_dialog = index
	print("seleced dialog is %s" % selected_dialog)

func _on_delete_dialog_button_pressed():
	print("Removing %s" % [selected_dialog])
	EditorState.edited_sequence.event_list[EditorState.selected_index].entry_list.remove_at(selected_dialog)
	_refresh_dialog_list()
