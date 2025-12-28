# EditorField.gd
@tool
extends Control

var EntryList = []

func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    print("Connected Editor Field to GUI input.")
    connect("gui_input", Callable(self, "_on_input"))

func _on_input(event):
    if event is InputEventMouseButton and event.pressed:
        EntryList.append(event.position)
        print("Click at: ", event.position)
        queue_redraw()

func _draw():
    for entry in EntryList:
        draw_circle(entry, 5.0, Color.RED)

func get_entries():
    return EntryList

func load_entries(new_entryList):
    """Sets the entryList known by the editor field, like when loading.
    """    
    EntryList = new_entryList

