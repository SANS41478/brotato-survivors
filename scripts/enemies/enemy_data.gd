class_name EnemyData
extends Resource

## 敌人数据 Resource — 定义敌人的所有属性

enum BehaviorType { CHASE, CHARGE, RANGED, BOSS }

@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export var behavior: BehaviorType = BehaviorType.CHASE

@export var max_hp: float = 20.0
@export var move_speed: float = 80.0
@export var contact_damage: float = 10.0
@export var xp_value: int = 1
@export var gold_value: int = 1
@export var size: float = 14.0          # 碰撞半径
@export var color: Color = Color.RED
@export var is_elite: bool = false
