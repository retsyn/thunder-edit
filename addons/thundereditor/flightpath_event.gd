@tool
extends StageEvent

class_name FlightPathEvent

@export var node: String


func to_dict():
    return {
        "node": node
    }
    

func from_dict(data: Dictionary):
    if data.has("node"):
        node = data["node"]