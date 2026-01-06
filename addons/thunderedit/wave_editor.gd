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
	level_data = LevelSequence.new()
	init_pages(64) # HARD LIMIT? 

	# Connect the custom signal
	editor_field.connect("data_edited", Callable(self, "capture_page"))

func init_pages(page_count: int):
	level_data.page_list = []
	for i in range(page_count):
		level_data.page_list.append(null)


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
		"Save As":
			print("Saving as...")
			if plugin:
				plugin.show_save_dialog()

		"Save":
			print("Saving!")


func _on_game_menu_item_pressed(id: int):
	var item_name = $VBoxContainer/MenuBar/GameMenu.get_popup().get_item_text(id)
	print(item_name)
	match item_name:
		"Load Game IDs":
			print("Loading Game IDs...")
			if plugin:
				plugin.show_game_open_dialog()
				

func set_plugin(p: EditorPlugin):
	plugin = p


func refresh_page():
	var pagelabel = $Panel2/EditorField/PageCount
	pagelabel.text = "P:%d" % CurrentPage
	editor_field.load_entries(level_data.page_list[CurrentPage])


func page_up():
	if(CurrentPage < 64):
		CurrentPage += 1
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
	print(JSON.stringify(level_data.to_dict()))
	var page_count = len(level_data.page_list)
	var foe_count = "UNKNOWN"
	print("Level Data has %s Pages with a total of %s Foes." % [page_count, foe_count])

	# for page in level_data.page_list:
	# 	if(page == null):

	# 		continue
	# 	print("Page %s:" % page)
	# 	for enemy in page.enemies_list:
	# 		print("    Enemy at %s, type: %s, mind: %s" % [enemy.position, enemy.enemy_id, enemy.mind])