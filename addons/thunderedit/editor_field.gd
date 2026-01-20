# EditorField.gd
@tool
extends Control

var plugin: EditorPlugin
@export var local_wave_data: Array[EnemyData] = []

#@onready var DotScene = preload("res://addons/thunderedit/dot.tscn")
# The "dot scene" isn't the route I'm going to go, yet.

var enemy_type_data: Array = []
var current_foe_selection: int


signal data_edited
signal tried_write_without_json


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
    var pos_match = false
    for i in range(local_wave_data.size() - 1, -1, -1):
        if local_wave_data[i].position == event.position.snapped(Vector2(10, 10)):
            var enemy_type = local_wave_data[i].enemy_id
            print("Selected %s at %s" % [enemy_type, local_wave_data[i].position])
            EditorInterface.get_inspector().edit(local_wave_data[i])

func _handle_left_click(event):
    if enemy_type_data == []:
        print("Must load a Game IDs json.")
        emit_signal("tried_write_without_json", 0)
        return
    var new_data = EnemyData.new()
    
    new_data.position = event.position.snapped(Vector2(10, 10))
    new_data.enemy_id = current_foe_selection
    var pos_match = false
    for i in range(local_wave_data.size() - 1, -1, -1):
        if local_wave_data[i].position == new_data.position:
            local_wave_data.remove_at(i)
            pos_match = true
    if(pos_match == false):
        local_wave_data.append(new_data)
    queue_redraw()        
    emit_signal("data_edited")

func update_foe_type(int):
    current_foe_selection = int

func load_enemy_type_data(data):
    print("Loaded type data:\n", data)
    var count = 0
    enemy_type_data = data

func look_up_data(i):
    return enemy_type_data[i]

func _draw():
    for entry in local_wave_data:
        var colour_data = enemy_type_data[entry.enemy_id]["colour"]
        var new_colour = Color(colour_data[0], colour_data[1], colour_data[2])
        draw_circle(entry.position, 5.0, new_colour)

func get_wave_data():
    var page = LevelPage.new()

    # Convert each visual entry (e.g. Vector2s) into EnemyData
    for local_enemy in local_wave_data:
        var enemy = EnemyData.new()
        enemy.position = local_enemy.position
        enemy.enemy_id = local_enemy.enemy_id
        enemy.mind = local_enemy.mind
        page.enemies_list.append(enemy)

    return page

func load_entries(new_entryList):
    """Sets the entryList known by the editor field, like when loading.
    """
    if new_entryList == null:
        local_wave_data = []
        queue_redraw()
        return

    local_wave_data = []
    for entry in new_entryList.enemies_list:
        var new_data = EnemyData.new()
        new_data.position = entry.position
        new_data.enemy_id = entry.enemy_id
        local_wave_data.append(new_data)
    queue_redraw()

func set_plugin(p: EditorPlugin):
    plugin = p
