@tool
extends Resource

class_name Sequence

@export var event_list: Array[StageEvent] = []

func to_dict():
    var serialized_events: Array[Dictionary] = []
    for event in event_list:
        if(event):
            serialized_events.append(event.to_dict())
        return {"events": serialized_events}

func from_dict(data: Dictionary):
    event_list.clear()
    if "events" not in data:
        push_error("Bad JSON-- no 'events' key.")
    for event_dict in data["events"]:
        var new_event := StageEvent.new()
        new_event.from_dict(event_dict)
        event_list.append(new_event)
    