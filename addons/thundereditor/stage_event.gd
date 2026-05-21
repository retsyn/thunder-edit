@tool
extends Resource

class_name StageEvent

# Placeholders have loud failures if child doesn't implement the essentials.
func to_dict():
    push_error("Child Class not implemented by %s" % get_class())

func from_dict(data: Dictionary):
    push_error("Child Class not implemented by %s" % get_class())