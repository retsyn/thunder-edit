extends Control

var plugin: EditorPlugin
var wave_editor_field = $Sequence/SequenceHBox/TabContainer/CombatWave/WaveControlsVBox/Wave/EditorField

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_plugin(p: EditorPlugin):
	print("Plugin set.")
	plugin = p


func get_editorfield():
	return wave_editor_field