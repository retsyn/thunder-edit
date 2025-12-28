@tool
extends Control

var editor_field: Control
var plugin: EditorPlugin

# Exposed Nodes
@export var EnemyList: ItemList

# Current state
var SelectedType: int
var CurrentPage: int



func _ready():
	editor_field = $Panel2/EditorField
	editor_field.mouse_filter = Control.MOUSE_FILTER_STOP
	var file_popup = $VBoxContainer/MenuBar/FileMenu.get_popup()
	var game_popup = $VBoxContainer/MenuBar/GameMenu.get_popup()
	file_popup.connect("id_pressed", Callable(self, "_on_file_menu_item_pressed"))
	game_popup.connect("id_pressed", Callable(self, "_on_game_menu_item_pressed"))
	EnemyList = $HBoxContainer3/VBoxContainer2/FoeList

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