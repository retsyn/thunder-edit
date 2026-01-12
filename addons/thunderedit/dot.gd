extends Control


@export var enemy_data: EnemyData
@export var is_selected:= false
@export var drag_offset := Vector2.ZERO

signal dot_selected(dot)


func _ready():
    mouse_filter = MOUSE_FILTER_STOP

func _gui_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.is_pressed():
            is_selected = true
            drag_offset = get_global_mouse_position() - global_position
            emit_signal("dot_selected", self)
    elif event is InputEventMouseMotion and is_selected and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
        global_position = get_global_mouse_position() - drag_offset
        enemy_data.position = global_position

func deselect():
    is_selected = false