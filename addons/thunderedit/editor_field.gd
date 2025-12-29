# EditorField.gd
@tool
extends Control

var plugin: EditorPlugin
@export var local_wave_data: Array = []


func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    print("Connected Editor Field to GUI input.")
    connect("gui_input", Callable(self, "_on_input"))


func _on_input(event):
    if event is InputEventMouseButton and event.pressed:
        local_wave_data.append(event.position)
        queue_redraw()


func _draw():
    for entry in local_wave_data:
        draw_circle(entry, 5.0, Color.RED)


func get_wave_data(wave_data):
    local_wave_data = wave_data


func load_entries(new_entryList):
    """Sets the entryList known by the editor field, like when loading.
    """    
    local_wave_data = new_entryList


func set_plugin(p: EditorPlugin):
    plugin = p