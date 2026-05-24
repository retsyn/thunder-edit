extends StageEvent
class_name FlagEvent

@export var flagname: String
@export var setting: bool

func to_dict():
    return {
        "setting": setting, "flagname": flagname
    }
    
func from_dict(data: Dictionary):
    if data.has("setting"):
        setting = data["setting"]
    else:
        push_error("Bad flag event in JSON.  No 'setting' key.")

    if data.has("flagname"):
        flagname = data["flagname"]
    else:
        push_error("Bad flag event in JSON.  No 'flagname' key.")

