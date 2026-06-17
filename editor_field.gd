extends Control

@export var local_wave_data: Array[EnemyData] = []

var current_foe_selection: int
var current_page: CombatPage = null

signal data_edited
signal tried_write_without_enemies


func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    print("Connected Editor Field to GUI input.")
    connect("gui_input", Callable(self, "_on_input"))


func _on_input(event):
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                _handle_left_click(event)
            MOUSE_BUTTON_RIGHT:
                _handle_right_click(event)


func _handle_right_click(event):
    #var pos_match = false
    for i in range(local_wave_data.size() - 1, -1, -1):
        if local_wave_data[i].position == event.position.snapped(Vector2(10, 10)):
            var enemy := local_wave_data[i]
            EditorInterface.get_inspector().edit(enemy)

            if not enemy.changed.is_connected(_on_enemy_changed):
                enemy.changed.connect(_on_enemy_changed)
            break


func _handle_left_click(event):
    if EditorState.enemy_types == []:
        print("Must load a Game IDs json.")
        emit_signal("tried_write_without_enemies", 0)
        return
    var new_data = EnemyData.new()
    
    new_data.position = event.position.snapped(Vector2(10, 10))
    new_data.enemy_id = EditorState.selected_enemy
    var pos_match = false
    for i in range(local_wave_data.size() - 1, -1, -1):
        if local_wave_data[i].position == new_data.position:
            local_wave_data.remove_at(i)
            pos_match = true
    if(pos_match == false):
        local_wave_data.append(new_data)
    queue_redraw()        
    emit_signal("data_edited")


func _on_enemy_changed():
    emit_signal("data_edited")
    queue_redraw()


func update_foe_type(type_int):
    current_foe_selection = type_int


func look_up_data(i):
    return EditorState.enemy_types[i]


func _draw():
    for entry in local_wave_data:
        var colour_data = EditorState.enemy_types[entry.enemy_id]["colour"]
        var new_colour = Color(colour_data[0], colour_data[1], colour_data[2])
        draw_circle(entry.position, 5.0, new_colour)


func get_wave_data():
    return current_page


func load_entries(new_page):
    """Sets the entryList known by the editor field, like when loading.
    """
    current_page = new_page
    if current_page == null:
        local_wave_data = []
        queue_redraw()
        return
    else:
        local_wave_data = current_page.enemies_list

    queue_redraw()
