@tool
extends Control

var editor_field: Control
var plugin: EditorPlugin

# Exposed Nodes
@export var EnemyList: ItemList

# Current state
var SelectedType: int
@export var CurrentPage: int
@export var level_data: LevelSequence
@onready var foe_selection_list: ItemList = $HBoxContainer3/VBoxContainer2/FoeList

var last_save_path = ""


func _ready():
	editor_field = $Panel2/EditorField
	editor_field.mouse_filter = Control.MOUSE_FILTER_STOP
	var file_popup = $VBoxContainer/MenuBar/FileMenu.get_popup()
	var game_popup = $VBoxContainer/MenuBar/GameMenu.get_popup()
	file_popup.connect("id_pressed", Callable(self, "_on_file_menu_item_pressed"))
	game_popup.connect("id_pressed", Callable(self, "_on_game_menu_item_pressed"))
	EnemyList = $HBoxContainer3/VBoxContainer2/FoeList
	var debug_button = $HBoxContainer2/DebugButton
	debug_button.pressed.connect(debug_out)
	$HBoxContainer/PageLeft.pressed.connect(page_down)
	$HBoxContainer/PageRight.pressed.connect(page_up)
	$HBoxContainer2/PathTypeButton.item_selected.connect(_on_pagetype_changed)
	level_data = LevelSequence.new()
	level_data.page_list.append(LevelPage.new())
	refresh_page()

	
	# Connect the custom signal
	editor_field.connect("data_edited", Callable(self, "capture_page"))
	editor_field.connect("tried_write_without_json", Callable(self, "_on_game_menu_item_pressed"))
	foe_selection_list.item_selected.connect(_on_foetype_select)


func _on_foetype_select(index: int):
	var selected = foe_selection_list.get_selected_items()
	if selected.size() > 0:
		var selected_index = selected[0]
		editor_field.update_foe_type(selected_index)

func init_pages(page_count: int):
	print("initializing pages!")
	level_data.page_list = []
	for i in range(page_count):
		level_data.page_list.append(LevelPage.new())


func get_editorfield():
	return editor_field


func _on_file_menu_item_pressed(id: int):
	var item_name = $VBoxContainer/MenuBar/FileMenu.get_popup().get_item_text(id)
	match item_name:
		"Load":
			print("Opening file...")
			if plugin:
				plugin.show_open_dialog()
			else:
				push_error("Plugin reference not set.")
		"Save as JSON":
			if plugin:
				plugin.show_save_dialog()

		"Save":
			if(last_save_path != ""):
				print("Saving %s" % last_save_path)				
				plugin.save_wave_data(last_save_path)

		"New":
			level_data = LevelSequence.new()
			CurrentPage = 0
			init_pages(1)
			refresh_page()


func _on_game_menu_item_pressed(id: int):
	var item_name = $VBoxContainer/MenuBar/GameMenu.get_popup().get_item_text(id)
	match item_name:
		"Load Game IDs":
			print("Loading Game IDs...")
			if plugin:
				plugin.show_game_open_dialog()


func _on_pagetype_changed(index):
	level_data.page_list[CurrentPage].cruise_type = index
	print("set cruise type on %d to %d" % [CurrentPage, index])


func set_plugin(p: EditorPlugin):
	plugin = p


func refresh_page():
	var pagelabel = $Panel2/EditorField/PageCount
	pagelabel.text = "P:%d/%d" % [CurrentPage, level_data.page_list.size() - 1]

	if CurrentPage < level_data.page_list.size():
		var page = level_data.page_list[CurrentPage]
		editor_field.load_entries(page)
		$HBoxContainer2/PathTypeButton.select(page.cruise_type)
	else:
		$HBoxContainer2/PathTypeButton.select(0)


func page_up():
	
	CurrentPage += 1
	if(CurrentPage >= level_data.page_list.size()):
		print("Adding a fresh page.")
		level_data.page_list.append(LevelPage.new())
	refresh_page()
	

func page_down():
	if(CurrentPage > 0):
		CurrentPage -= 1
		refresh_page()


func load_enemy_types(json_path: String):
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		push_error("Failed to open file: %s" % json_path)
		return []

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_string)

	if parse_result != OK:
		push_error("JSON parse error: %s" % json.get_error_message())
		return []

	var root = json.get_data()
	if not root.has("enemy_types") or typeof(root["enemy_types"]) != TYPE_ARRAY:
		push_error("Missing or invalid 'enemy_types' array.")
		return []

	return root["enemy_types"]


# func data_edited():
# 	plugin.ref


func capture_page():

	level_data.page_list[CurrentPage] = editor_field.get_wave_data()


func debug_out():
	print(JSON.stringify(level_data.to_dict(), "\t"))
	var page_count = len(level_data.page_list)
	var foe_count = "UNKNOWN"
	
	# for page in level_data.page_list:
	# 	if(page == null):

	# 		continue
	# 	print("Page %s:" % page)
	# 	for enemy in page.enemies_list:
	# 		print("    Enemy at %s, type: %s, mind: %s" % [enemy.position, enemy.enemy_id, enemy.mind])