@tool
extends Resource

class_name LevelPage

@export var enemies_list: Array[EnemyData] = []
@export var flip_type: int
@export var approach_type: int
@export var cruise_type: int
@export var timer: float

func to_dict():
    var serial_enemy_list: Array[Dictionary] = []
    for enemy in enemies_list:
        serial_enemy_list.append(enemy.to_dict())
    return {
        "enemies_list": serial_enemy_list,
        "flip_type": flip_type,
        "timer": timer,
        "cruise_type": cruise_type,
        "approach_type": approach_type
    }

func from_dict(data: Dictionary):
    print("\n\nADDING A PAGE\n\n")
    if(data.has("enemies_list")):
        print("--\nAdding an 'enemies_list' entry\n--")
        enemies_list = []
        for enemy in data["enemies_list"]:
            var new_enemy:= EnemyData.new()
            new_enemy.from_dict(enemy)
            enemies_list.append(new_enemy)
    flip_type = data["flip_type"]
    timer = data["timer"]
    cruise_type = data["cruise_type"]
    approach_type = data["approach_type"]
