@tool
extends Resource


class_name LevelSequence

var page_list: Array[LevelPage] = []

func to_dict():
    var serial_pages: Array[Dictionary] = []
    for page in page_list:
        if(page):
            serial_pages.append(page.to_dict())

    return serial_pages