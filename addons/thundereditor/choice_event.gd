@tool

extends StageEvent
class_name ChoiceEvent

@export var top_choice_name: String
@export var top_choice_branch: String
@export var left_choice_name: String
@export var left_choice_branch: String
@export var bottom_choice_name: String
@export var bottom_choice_branch: String
@export var right_choice_name: String
@export var right_choice_branch: String


func to_dict():
    return {
        "top_choice_name": top_choice_name,
        "top_choice_branch": top_choice_branch,
        "left_choice_name": left_choice_name,
        "left_choice_branch": left_choice_branch,
        "bottom_choice_name": bottom_choice_branch,
        "bottom_choice_branch": bottom_choice_branch,
        "right_choice_name": right_choice_name,
        "right_choice_branch": right_choice_branch,
    }


func from_dict(data: Dictionary):
    top_choice_name = data["top_choice_name"]
    top_choice_branch = data["top_choice_branch"]
    left_choice_name = data["left_choice_name"]
    left_choice_branch = data["left_choice_branch"]
    bottom_choice_name = data["bottom_choice_name"]
    bottom_choice_branch = data["bottom_choice_branch"]
    right_choice_name = data["right_choice_name"]
    right_choice_branch = data["right_choice_branch"]