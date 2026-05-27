extends Control

@onready var dialog_list = $DialogVBox/DialogEntries
@onready var selected_dialog = 0

func _on_insert_dialog_button_pressed():
	print("Insert Dialog Pressed")
	var new_dialog = DialogEvent.new()
	EditorState.edited_sequence.event_list[EditorState.selected_index] = new_dialog
	_add_dialog(new_dialog)


func _add_dialog(new_element):
	print("Inserting Dialog")
	var event = EditorState.edited_sequence.event_list[EditorState.selected_index]
	if(event is DialogEvent):
		if(selected_dialog == 0):
			event.append_entry(1, "something")
		else:
			event.insert_entry(1, "something", selected_dialog)
	
	_refresh_dialog_list()	


func _refresh_dialog_list():
	dialog_list.clear()
	var index_counter = 0
	for event in EditorState.edited_sequence.event_list[EditorState.selected_index].entry_list:
		index_counter += 1
		dialog_list.add_item("%s. " % index_counter)
