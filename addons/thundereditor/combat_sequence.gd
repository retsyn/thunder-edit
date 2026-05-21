@tool
class_name CombatSequence
extends StageEvent



@export var page_list: Array[CombatPage] = []
@export var version: int = 1

func to_dict():
    var serial_pages: Array[Dictionary] = []
    for page in page_list:
        if (page):
            serial_pages.append(page.to_dict())
    return {"pages": serial_pages}

func from_dict(data: Dictionary):
    page_list.clear()
    if "pages" not in data:
        push_error("Malformed JSON-- no 'pages' key.")
    for page_dict in data["pages"]:
        var new_page := CombatPage.new()
        new_page.from_dict(page_dict)
        page_list.append(new_page)