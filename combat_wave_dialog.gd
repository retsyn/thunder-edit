
extends HBoxContainer
@onready var EntityPalette = $MarginContainer/EntityPaletteVBox/EntitySelectList
@onready var CurrentPage = 0


func _on_page_left_button_pressed():
	turn_page_left()

func _on_page_right_button_pressed():
	turn_page_right()


func turn_page_left():
	if(CurrentPage > 0):
		CurrentPage -= 1

func turn_page_right():
	CurrentPage += 1
	if (CurrentPage >= EditorState.edited_sequence[EditorState.selected_index].level_data.size()):
		print("Adding a fresh page.")
		EditorState.edited_sequence[EditorState.selected_index].level_data.page_list.append(CombatPage.new())
		EditorState.edited_sequence[EditorState.selec]

	refresh_page()





func page_up():
	CurrentPage += 1
	

func page_down():
	if (CurrentPage > 0):
		CurrentPage -= 1
		refresh_page()




func _on_page_two_button_pressed() -> void:
	pass # Replace with function body.
