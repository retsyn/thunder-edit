@tool
extends Resource

class_name LevelPage

var enemies_list: Array[EnemyData] = []
var flip_type: int
var timer: float

func to_dict():
    var serial_enemy_list: Array[Dictionary] = []
    for enemy in enemies_list:
        serial_enemy_list.append(enemy.to_dict())
    return {
        "enemies_list": serial_enemy_list,
        "flip_type": flip_type,
        "timer": timer
    }

func from_dict(data: Dictionary):
    if data.has("enemies_list"):
        enemies_list = []
        for enemy in data["enemies_list"]:
            var new_enemy: EnemyData
            new_enemy.enemy_id = enemy["enemy_id"]
            new_enemy.position = enemy["position"]
            new_enemy.mind = enemy["mind"]
            enemies_list.append(new_enemy)
        flip_type = data["flip_type"]
        timer = data["timer"]