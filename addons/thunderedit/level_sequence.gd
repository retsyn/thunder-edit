@tool
extends Resource


class_name LevelSequence

var page_list: Array[LevelPage] = []

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
        var new_page := LevelPage.new()
        new_page.from_dict(page_dict)
        page_list.append(new_page)
