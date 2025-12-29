@tool
extends EditorPlugin

var wave_editor_dock
var editor_field
var file_dialog: EditorFileDialog

var wave_file_path: String
var game_file_path: String

@export var sequence_data: LevelSequence

func _enable_plugin():
	# Add autoloads here.
	pass


func _disable_plugin():
	# Remove autoloads here.
	pass


func _enter_tree():
	# Initialization of the plugin goes here.
	wave_editor_dock = preload("res://addons/thunderedit/wave_editor.tscn").instantiate()
	wave_editor_dock.set_plugin(self)

	add_control_to_dock(DOCK_SLOT_RIGHT_BL, wave_editor_dock)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(wave_editor_dock)
	wave_editor_dock.queue_free()
	pass


func show_open_dialog():

	if file_dialog == null:
		file_dialog = EditorFileDialog.new()
		file_dialog.connect("file_selected", Callable(self, "_on_wave_file_selected"))
		get_editor_interface().get_base_control().add_child(file_dialog)

	file_dialog.clear_filters()
	file_dialog.add_filter("*.sws ; Shmup Wave Sequence files")

	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()


func show_game_open_dialog():

	if file_dialog == null:
		file_dialog = EditorFileDialog.new()
		file_dialog.connect("file_selected", Callable(self, "_on_game_file_selected"))
		get_editor_interface().get_base_control().add_child(file_dialog)

	file_dialog.clear_filters()
	file_dialog.add_filter("*.JSON ; Game info JSON files")

	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()
	

func show_save_dialog():
	if file_dialog == null:
		file_dialog = EditorFileDialog.new()
		file_dialog.connect("file_selected", Callable(self, "_on_wave_file_selected"))
		get_editor_interface().get_base_control().add_child(file_dialog)

	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()


func _on_wave_file_selected(path: String):
	print("Selected file:", path)
	wave_file_path = path


func _on_game_file_selected(path: String):
	print("Selected file:", path)
	game_file_path = path
	refresh_game_file()


func refresh_game_file():
	var enemy_defs = load_enemy_types(game_file_path)
	wave_editor_dock.EnemyList.clear() # clear existing items

	for enemy in enemy_defs:
		if enemy.has("id"):
			wave_editor_dock.EnemyList.add_item(enemy["id"])

func refresh_debug_text():
	print("FULL SEQUENCE\n%s" % sequence_data)

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
		push_error("No 'enemy_types' array.  Is this some other kind of JSON?")
		return []

	return root["enemy_types"]