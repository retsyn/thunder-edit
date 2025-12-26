@tool
extends Control

var editor_field: Control

var SelectedType: int

func _ready():
    editor_field = $Panel2/EditorField
    editor_field.mouse_filter = Control.MOUSE_FILTER_STOP


        