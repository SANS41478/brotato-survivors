class_name ProjectileData
extends Resource

## 弹幕数据 Resource — 定义弹幕的所有属性

@export var speed: float = 300.0
@export var damage: float = 10.0
@export var pierce: int = 0
@export var lifetime: float = 2.0
@export var knockback: float = 0.0
@export var scale: float = 1.0
@export var color: Color = Color.WHITE
@export var aoe_radius: float = 0.0           # >0 表示命中时爆炸
