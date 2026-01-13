@tool
extends Resource

class_name EnemyData

var enemy_id: int
var position: Vector2
var mind: int

func to_dict():
    return {
        "enemy_id": enemy_id,
        "position": { "x": position.x, "y": position.y},
        "mind": mind
    }

func from_dict(data: Dictionary):
    if data.has("enemy_id"):
        enemy_id = data["enemy_id"]
    if data.has("position"):
        var pos = data["position"]
        position = Vector2(float(pos["x"]), float(pos["y"]))
    if data.has("mind"):
        mind = data["mind"]
