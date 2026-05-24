extends StageEvent
class_name DialogEvent

@export var entry_list: Array[Dictionary] = []

func append_entry(portrait: int, text: String):
    print("Adding dialog entry!")
    var new_entry: Dictionary[String, String] = {"portrait": str(portrait), "text": text}
    entry_list.append(new_entry)


func insert_entry(portrait: int, text: String, index: int):
    print("Inserting dialog entry at index %s" % index)
    var new_entry: Dictionary[String, String] = {"portrait": str(portrait), "text": text}
    entry_list.insert(index, new_entry)


func to_dict():
    return {"dialogs": entry_list}


func from_dict(data: Dictionary):
    entry_list.clear()
    if "dialogs" not in data:
        push_error("Malformed JSON: no 'dialogs' key.")
    entry_list.append(data["dialogs"])