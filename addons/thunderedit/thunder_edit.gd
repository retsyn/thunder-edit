@tool
extends EditorPlugin

var wave_editor_dock
var file_dialog: EditorFileDialog

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
		file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
		get_editor_interface().get_base_control().add_child(file_dialog)

	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()


func show_save_dialog():
	if file_dialog == null:
		file_dialog = EditorFileDialog.new()
		file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
		get_editor_interface().get_base_control().add_child(file_dialog)

	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()


func _on_file_selected(path: String):
	print("Selected file:", path)