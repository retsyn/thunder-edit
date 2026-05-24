extends StageEvent 
class_name GotoEvent

@export var target_branch: String
@export var condition_type: int
@export var flag: String

func to_dict():
    return {
        "target_branch": target_branch,
        "condition_type": condition_type,
        "flag": flag
    }

func from_dict(data: Dictionary):
    if data.has("target_branch"):
        target_branch = data["target_branch"]

    if data.has("condition_type"):
        condition_type = data["condition_type"]

    if data.has("flag"):
        flag = data["flag"]
        