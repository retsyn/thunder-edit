@tool
extends Control

var editor_field: Control
var SelectedType: int
var plugin: EditorPlugin

func _ready():
	editor_field = $Panel2/EditorField
	editor_field.mouse_filter = Control.MOUSE_FILTER_STOP
	var popup = $VBoxContainer/MenuBar/FileMenu.get_popup()
	popup.connect("id_pressed", Callable(self, "_on_file_menu_item_pressed"))

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
				

func set_plugin(p: EditorPlugin) -> void:
	plugin = p

	
