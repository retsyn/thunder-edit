
extends StageEvent

class_name BranchEvent

@export var target_name: String


func to_dict():
    return {
        "target_name": target_name
    }
    

func from_dict(data: Dictionary):
    
    if data.has("target_name"):
        target_name = data["target_name"]

