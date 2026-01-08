# EditorField.gd
@tool
extends Control

var plugin: EditorPlugin
@export var local_wave_data: Array[EnemyData] = []
var enemy_type_data: Array = []
var current_foe_selection: int

signal data_edited


func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    print("Connected Editor Field to GUI input.")
    connect("gui_input", Callable(self, "_on_input"))


func _on_input(event):
    if event is InputEventMouseButton and event.pressed:
        var new_enemy = EnemyData.new()
        new_enemy.position = event.position
        new_enemy.enemy_id = current_foe_selection
        local_wave_data.append(new_enemy)
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
        var new_enemy = EnemyData.new()
        new_enemy.position = entry.position
        new_enemy.enemy_id = entry.enemy_id
        local_wave_data.append(new_enemy)
    queue_redraw()

func set_plugin(p: EditorPlugin):
    plugin = p