@tool
extends Resource

class_name FlagData

@export var flagname: String
@export var set: bool

func to_dict():
    return {
        "set": set, "flagname": flagname
    }
    