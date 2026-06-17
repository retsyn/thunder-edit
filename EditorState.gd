extends Node

var edited_sequence = Sequence.new()
var selected_index = -1
@export var enemy_types: Array[Dictionary] = []
@export var selected_enemy: int



# signal current_event_changed(new_index: int)
# signal event_modified(page_index: int)


func get_current_event() -> StageEvent:
	if edited_sequence and selected_index < edited_sequence.event_list.size():
		return edited_sequence.event_list[selected_index]
	return null


func new_sequence():
	edited_sequence = Sequence.new()
