
@tool
extends StageEvent 
class_name EndEvent


@export var end_type: int

func to_dict():
    return {
        "end_type": end_type
    }

func from_dict(data: Dictionary):
    if data.has("end_type"):
        end_type = data["end_type"]
        