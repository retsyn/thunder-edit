# EditorField.gd
@tool
extends Control

var plugin: EditorPlugin
@export var local_wave_data: Array[EnemyData] = []

signal data_edited


func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    print("Connected Editor Field to GUI input.")
    connect("gui_input", Callable(self, "_on_input"))


func _on_input(event):
    if event is InputEventMouseButton and event.pressed:
        var new_enemy = EnemyData.new()
        new_enemy.position = event.position
        local_wave_data.append(new_enemy)
        queue_redraw()
        emit_signal("data_edited")
        print("Emitting signal!")


func _draw():
    for entry in local_wave_data:
        draw_circle(entry.position, 5.0, Color.RED)

func get_wave_data():
    var page = LevelPage.new()

    # Convert each visual entry (e.g. Vector2s) into EnemyData
    for local_enemy in local_wave_data:
        print("Local enemy data was %s" % local_enemy)
        var enemy = EnemyData.new()
        enemy.position = local_enemy.position
        enemy.enemy_id = 0 # TODO set this to the selection!
        enemy.mind = 0 # TODO set this to the selection
        page.enemies_list.append(enemy)

    return page

func load_entries(new_entryList):
    """Sets the entryList known by the editor field, like when loading.
    """    
    print("Loading entries from given page:\n%s" % new_entryList)
    local_wave_data = []
    for entry in new_entryList.enemies_list:
        var new_enemy = EnemyData.new()
        new_enemy.position = entry.position
        local_wave_data.append(new_enemy)
    queue_redraw()

func set_plugin(p: EditorPlugin):
    plugin = p