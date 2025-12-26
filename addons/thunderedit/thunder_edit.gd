@tool
extends EditorPlugin

var wave_editor_dock
func _enable_plugin():
	# Add autoloads here.
	pass


func _disable_plugin():
	# Remove autoloads here.
	pass


func _enter_tree():
	# Initialization of the plugin goes here.
	wave_editor_dock = preload("res://addons/thunderedit/wave_editor.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, wave_editor_dock)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(wave_editor_dock)
	wave_editor_dock.queue_free()
	pass
