
@tool
extends StageEvent

class_name CinemaEvent

@export var path: String


func to_dict():
    return {
        "path": path
    }
    